@echo off
setlocal
set "SOURCE=D:\mine\apps\attend"
set "TARGET=T:\"

if not exist "%TARGET%docker-compose.yml" (
    echo ERROR: %TARGET%docker-compose.yml not found
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

echo attend: restart docker
pushd "%TARGET%"
docker compose up -d
docker compose restart attend
set ERR=%ERRORLEVEL%
popd

if not "%ERR%"=="0" (
    echo ERROR: docker failed
    pause
    exit /b 1
)

echo attend: NAS sync done
echo check: http://NAS-IP:8102/api/status
pause
