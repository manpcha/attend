@echo off
setlocal
cd /d %~dp0

echo attend: build docker image on PC (needs Docker Desktop)
docker build -t attend:latest .
if errorlevel 1 (
    echo ERROR: docker build failed
    pause
    exit /b 1
)

echo attend: save image to attend-image.tar
docker save attend:latest -o attend-image.tar
if errorlevel 1 (
    echo ERROR: docker save failed
    pause
    exit /b 1
)

echo.
echo attend: done - attend-image.tar created
echo NEXT:
echo   1. robocopy attend-image.tar docker-compose.nas.yml T:\
echo   2. on NAS SSH: docker load -i attend-image.tar
echo   3. on NAS SSH: docker compose -f docker-compose.nas.yml up -d
echo.
pause
