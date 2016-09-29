@echo off
title Batch FTP Deploy - Upload Only

REM Connetion variables
set user=YOUR_USERNAME
set password=YOUR_PASSWORD
set server=YOUR_SERVERNAME

REM Define directories
set resource_dir=YOUR_RESOURCE_DIRECTORY
set remote_dir=YOUR_REMOTE_DIRECTORY

REM -------------------------
REM Dont edit below this line

cd %resource_dir%
ncftpput -u %user% -p %password% -R %server% %remote_dir% .\*

REM echo -------------------------
REM echo Resource upload completed
REM pause