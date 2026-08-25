@echo off
setlocal
set "SOURCE=D:\mine\apps\attend"
set "TARGET=T:\"

if not exist "%TARGET%docker-compose.yml" (
    echo ERROR: %TARGET%docker-compose.yml not found
    echo        connect network drive T: to \\dandycha\docker\attend
    pause
    exit /b 1
)

echo attend: copy %SOURCE% -^> %TARGET%
robocopy "%SOURCE%" "%TARGET%" /E /XD .git __pycache__ data /XF *.pyc /NFL /NDL /NJH /NJS
if %ERRORLEVEL% GEQ 8 (
    echo ERROR: robocopy failed
    pause
    exit /b 1
)

echo.
echo attend: files copied to NAS share
echo.
echo NEXT: restart docker ON THE NAS (not on T: drive)
echo   - DSM Container Manager: restart attend container
echo   - or SSH: restart-nas-docker.bat
echo.
echo check: http://dandycha:8102/api/status
pause
