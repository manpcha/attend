@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync-to-nas.ps1" %*
exit /b %ERRORLEVEL%
