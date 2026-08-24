@echo off
chcp 65001 >nul
echo [attend] 이 스크립트는 sync-to-nas.bat 로 대체되었습니다.
echo [attend] PC에서 NAS로 복사합니다 (git/GitHub 사용 안 함).
call "%~dp0sync-to-nas.bat" %*
