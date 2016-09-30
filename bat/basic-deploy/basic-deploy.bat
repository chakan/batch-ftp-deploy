@echo off
title Batch FTP Deploy - Basic Deploy

REM Connetion variables
set user=YOUR_USERNAME
set password=YOUR_PASSWORD
set server=YOUR_SERVERNAME

REM Define directories
set resource_dir=YOUR_RESOURCE_DIRECTORY
set maintenance_dir=YOUR_MAINTENANCE_DIRECTORY
set backup_dir=YOUR_BACKUP_DIRECTORY
set remote_dir=YOUR_REMOTE_DIRECTORY
set site_dir_name=YOUR_SITE_DIRECTORY_NAME

REM ---------------------------------------------------------------------------
REM Dont edit below this line

REM Delete local backup
rmdir %backup_dir% /s /q
REM We need to wait here a bit, because sometimes it creates the dir before deleting it yay 
ping 127.0.0.1 -n 1
mkdir %backup_dir%

REM echo ---------------------------------------------------------------------------
REM echo Local backup deleted, we are starting maintenance mode next
REM pause

REM Set starting dir just in case the connection fails
cd %backup_dir%

REM FTP connection
echo user %user%> ftp.tmp
echo %password%>> ftp.tmp
echo bin>> ftp.tmp

REM Begin maintenance
echo cd %remote_dir%>>ftp.tmp
echo lcd %backup_dir%>>ftp.tmp
echo get index.html>> ftp.tmp
echo get .htaccess>> ftp.tmp
echo lcd %maintenance_dir%>> ftp.tmp
echo delete index.html>> ftp.tmp
echo put index.html>> ftp.tmp
echo delete .htaccess>> ftp.tmp
echo put .htaccess>> ftp.tmp
echo quit>> ftp.tmp
ftp -n -s:ftp.tmp %server%
del ftp.tmp

REM echo ---------------------------------------------------------------------------
REM echo Site was set into maintenance mode, possible index.html and .htaccess were downloaded
REM echo We are downloading and deleting remote files next
REM pause

REM Download server files
cd %backup_dir%
ncftpget -u %user% -p %password% -R -DD %server% %backup_dir% %remote_dir%
cd %site_dir_name%
del index.html
del .htaccess
cd ..
copy index.html %backup_dir%\%site_dir_name%
copy .htaccess %backup_dir%\%site_dir_name%
del index.html
del .htaccess

REM echo ---------------------------------------------------------------------------
REM echo Backup download completed and all files on the server were deleted
REM echo We are about to enable maintenance mode again

REM Upload maintenance mode files again before we start the upload
cd %maintenance_dir%
ncftpput -u %user% -p %password% -R %server% %remote_dir% index.html
ncftpput -u %user% -p %password% -R %server% %remote_dir% .htaccess

REM echo ---------------------------------------------------------------------------
REM echo Maintenance mode was enabled again, upload is next
REM pause

REM Upload local files
cd %resource_dir%
rename index.html index_original.html
rename .htaccess .htaccess_original
ncftpput -u %user% -p %password% -R %server% %remote_dir% .\*

REM echo ---------------------------------------------------------------------------
REM echo Resource upload completed, we are going live next
REM pause

REM FTP connection
echo user %user%> ftp.tmp
echo %password%>> ftp.tmp
echo bin>> ftp.tmp

REM End maintenance and go live
echo cd %remote_dir%>>ftp.tmp
echo delete index.html>> ftp.tmp
echo rename index_original.html index.html>> ftp.tmp
echo delete .htaccess>> ftp.tmp
echo rename .htaccess_original .htaccess>> ftp.tmp
echo quit>> ftp.tmp
ftp -n -s:ftp.tmp %server%
del ftp.tmp

REM echo ---------------------------------------------------------------------------
REM echo Site is now live! You can access the backup here: %backup_dir%
REM pause
