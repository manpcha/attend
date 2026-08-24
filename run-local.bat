@echo off
chcp 65001 >nul
cd /d %~dp0

if not exist data mkdir data

set DATA_DIR=%~dp0data
echo.
echo ========================================
echo  attend 로컬 서버
echo  DATA_DIR=%DATA_DIR%
echo  주소: http://127.0.0.1:8102
echo  상태: http://127.0.0.1:8102/api/status
echo  (https 아님, 포트 앞 : 하나만)
echo ========================================
echo.

where python >nul 2>&1
if errorlevel 1 (
    echo [오류] python 이 설치되어 있지 않거나 PATH에 없습니다.
    pause
    exit /b 1
)

python -c "import uvicorn" >nul 2>&1
if errorlevel 1 (
    echo [attend] uvicorn 설치 중...
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [오류] 패키지 설치 실패
        pause
        exit /b 1
    )
)

echo [attend] 서버 시작 중... 이 창을 닫지 마세요.
echo.
python -m uvicorn app:app --host 127.0.0.1 --port 8102
if errorlevel 1 (
    echo.
    echo [오류] 서버 시작 실패. 포트 8102가 이미 사용 중일 수 있습니다.
    pause
)
