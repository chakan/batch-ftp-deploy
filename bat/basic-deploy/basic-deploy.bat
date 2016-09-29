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

REM -------------------------
REM Dont edit below this line

REM Delete local backup
rmdir c:\Users\Imre\Documents\NetBeansProjects\backup /s /q
mkdir c:\Users\Imre\Documents\NetBeansProjects\backup

REM echo -------------------------
REM echo Local backup deleted
REM pause

REM FTP connection
echo user %user%> ftp.tmp
echo %password%>> ftp.tmp
echo bin>> ftp.tmp

REM Begin maintenance
echo cd %remote_dir%>>ftp.tmp
echo lcd %backup_dir%>>ftp.tmp
echo get index.html>> ftp.tmp
echo get index.php>> ftp.tmp
echo get .htaccess>> ftp.tmp
echo delete index.html>> ftp.tmp
echo delete index.php>> ftp.tmp
echo delete .htaccess>> ftp.tmp
echo lcd %maintenance_dir%>> ftp.tmp
echo put index.html>> ftp.tmp
echo put .htaccess>> ftp.tmp
echo quit>> ftp.tmp
ftp -n -s:ftp.tmp cpanel8.tarhelypark.hu
del ftp.tmp

REM echo -------------------------
REM echo Site was set into maintenance mode
REM pause

REM Download server files
cd %backup_dir%
rename index.php index_original.php
rename index.html index_original.html
rename .htaccess .htaccess_original
ncftpget -u %user% -p %password% -R -DD %server% %remote_dir% %backup_dir%
delete index.html
delete index.php
delete .htaccess
rename index_original.php index.php
rename index_original.html index.html
rename .htaccess_original .htaccess

REM echo -------------------------
REM echo Backup download completed
REM pause

REM Upload local files
cd %resource_dir%
rename index.php index_original.php
rename index.html index_original.html
rename .htaccess .htaccess_original
ncftpput -u %user% -p %password% -R %server% %remote_dir% .\*

REM echo -------------------------
REM echo Resource upload completed
REM pause

REM FTP connection
echo user %user%> ftp.tmp
echo %password%>> ftp.tmp
echo bin>> ftp.tmp

REM End maintenance and go live
echo cd %remote_dir%>>ftp.tmp
echo delete index.html>> ftp.tmp
echo delete .htaccess>> ftp.tmp
echo rename index_original.php index.php>> ftp.tmp
echo rename index_original.html index.html>> ftp.tmp
echo rename .htaccess_original .htaccess>> ftp.tmp
echo quit>> ftp.tmp
ftp -n -s:ftp.tmp %server%
del ftp.tmp

REM echo -------------------------
REM echo Site is now live
REM pause
