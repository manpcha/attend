@echo off
rem Restart attend container ON NAS via SSH (not on T: network drive)
rem Edit NAS_HOST, NAS_USER, NAS_PATH if needed

set "NAS_HOST=dandycha"
set "NAS_USER=admin"
set "NAS_PATH=/volume1/docker/attend"

echo attend: SSH restart on %NAS_HOST%
echo path: %NAS_PATH%
echo.

ssh %NAS_USER%@%NAS_HOST% "cd %NAS_PATH% && docker compose restart attend"
if errorlevel 1 (
    echo.
    echo ERROR: SSH failed
    echo - check NAS_HOST / NAS_USER / NAS_PATH in this file
    echo - or restart manually in DSM Container Manager
    pause
    exit /b 1
)

echo.
echo attend: NAS docker restarted
pause
