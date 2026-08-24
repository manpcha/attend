@echo off
chcp 65001 >nul
setlocal

rem 로컬 PC(D:\mine\apps\attend)에 GitHub 최신 파일 받기. git 불필요.
set "TARGET=D:\mine\apps\attend"
if not "%~1"=="" set "TARGET=%~1"
if not "%TARGET:~-1%"=="\" set "TARGET=%TARGET%\"

echo [attend] GitHub -^> %TARGET%

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$base='https://raw.githubusercontent.com/manpcha/attend/master';" ^
  "$files=@('index.html','app.py','Dockerfile','docker-compose.yml','requirements.txt','run-local.bat','sync-to-nas.bat','pull-from-github.bat');" ^
  "foreach($f in $files){ Write-Host \"다운로드: $f\"; Invoke-WebRequest -Uri \"$base/$f\" -OutFile (Join-Path '%TARGET%' $f) -UseBasicParsing }"

if errorlevel 1 (
    echo 다운로드 실패
    pause
    exit /b 1
)

echo [attend] 완료. data 폴더는 그대로 유지됩니다.
pause
