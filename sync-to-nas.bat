@echo off
call "%~dp0sync-to-nas.cmd" %*
exit /b %ERRORLEVEL%
