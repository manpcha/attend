@echo off
chcp 65001 >nul
cd /d %~dp0

if not exist data mkdir data

set DATA_DIR=%~dp0data
echo [attend] DATA_DIR=%DATA_DIR%
echo [attend] http://127.0.0.1:8102

python -m uvicorn app:app --host 127.0.0.1 --port 8102
