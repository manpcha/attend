@echo off
chcp 65001 >nul
setlocal

set "TARGET=T:\"
if not "%~1"=="" set "TARGET=%~1"
if not "%TARGET:~-1%"=="\" set "TARGET=%TARGET%\"

echo [attend] NAS 업데이트 대상: %TARGET%

if not exist "%TARGET%docker-compose.yml" (
    echo 오류: %TARGET% 에 docker-compose.yml 이 없습니다.
    echo T: 드라이브가 \\dandycha\docker\attend 로 연결되어 있는지 확인하세요.
    pause
    exit /b 1
)

if exist "%TARGET%.git" (
    echo [attend] git pull 실행...
    pushd "%TARGET%"
    git pull origin master
    if errorlevel 1 (
        echo git pull 실패
        popd
        pause
        exit /b 1
    )
    popd
) else (
    echo [attend] GitHub에서 최신 파일 다운로드...
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update-nas.ps1" -Target "%TARGET%"
    if errorlevel 1 (
        pause
        exit /b 1
    )
)

echo [attend] Docker 컨테이너 재빌드 및 재시작...
pushd "%TARGET%"
docker compose down
docker compose up -d --build
set "ERR=%ERRORLEVEL%"
popd

if not "%ERR%"=="0" (
    echo Docker 재시작 실패
    pause
    exit /b 1
)

echo [attend] 업데이트 완료
pause
