@echo off
chcp 65001 >nul
setlocal

rem PC 로컬 -^> NAS(T:) 동기화. NAS에서 git/GitHub 사용 안 함.
set "SOURCE=D:\mine\apps\attend"
set "TARGET=T:\"

if not "%~1"=="" set "SOURCE=%~1"
if not "%~2"=="" set "TARGET=%~2"
if not "%TARGET:~-1%"=="\" set "TARGET=%TARGET%\"

echo [attend] 동기화: %SOURCE% -^> %TARGET%

if not exist "%SOURCE%\app.py" (
    echo 오류: %SOURCE%\app.py 없음
    pause
    exit /b 1
)
if not exist "%TARGET%docker-compose.yml" (
    echo 오류: %TARGET% 에 docker-compose.yml 없음. T: 드라이브 연결을 확인하세요.
    pause
    exit /b 1
)

robocopy "%SOURCE%" "%TARGET%" /E /XD .git __pycache__ /XF *.pyc /NFL /NDL /NJH /NJS
if %ERRORLEVEL% GEQ 8 (
    echo robocopy 오류
    pause
    exit /b 1
)

pushd "%TARGET%"
docker compose up -d
if errorlevel 1 (
    echo docker compose up 실패
    popd
    pause
    exit /b 1
)
docker compose restart attend
set "ERR=%ERRORLEVEL%"
popd

if not "%ERR%"=="0" (
    echo docker restart 실패
    pause
    exit /b 1
)

echo [attend] NAS 동기화 완료
echo [attend] 확인: http://NAS주소:8102/api/status
pause
