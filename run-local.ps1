# UTF-8 local server launcher
param(
    [string]$Root = $PSScriptRoot
)

$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()

if (-not $Root.EndsWith("\")) { $Root += "\" }
$dataDir = Join-Path $Root "data"
if (-not (Test-Path $dataDir)) { New-Item -ItemType Directory -Path $dataDir | Out-Null }

$env:DATA_DIR = $dataDir

Write-Host ""
Write-Host "========================================"
Write-Host " attend 로컬 서버"
Write-Host " DATA_DIR=$dataDir"
Write-Host " 주소: http://127.0.0.1:8102"
Write-Host " 상태: http://127.0.0.1:8102/api/status"
Write-Host " (https 아님, 포트 앞 : 하나만)"
Write-Host "========================================"
Write-Host ""

Set-Location $Root

try {
    python -c "import uvicorn" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[attend] 패키지 설치 중..."
        python -m pip install -r requirements.txt
    }
}
catch {
    Write-Host "[오류] python/uvicorn 확인 실패"
    exit 1
}

Write-Host "[attend] 서버 시작... 이 창을 닫지 마세요."
Write-Host ""
python -m uvicorn app:app --host 127.0.0.1 --port 8102
