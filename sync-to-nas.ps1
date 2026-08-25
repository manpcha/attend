# UTF-8 NAS sync script
param(
    [string]$Source = "D:\mine\apps\attend",
    [string]$Target = "T:\"
)

$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()
$ErrorActionPreference = "Stop"

if (-not $Target.EndsWith("\")) { $Target += "\" }
if (-not $Source.EndsWith("\")) { $Source += "\" }

Write-Host ""
Write-Host "========================================"
Write-Host " attend NAS 동기화"
Write-Host " 대상: $Target"
Write-Host "========================================"
Write-Host ""

if (-not (Test-Path (Join-Path $Target "docker-compose.yml"))) {
    Write-Host "[오류] docker-compose.yml 없음: $Target"
    Write-Host "       T: 드라이브가 \\dandycha\docker\attend 로 연결됐는지 확인하세요."
    exit 1
}

$gitDir = Join-Path $Target ".git"
if (Test-Path $gitDir) {
    Write-Host "[attend] NAS에 git 저장소 감지 -> git pull"
    Push-Location $Target
    try {
        git pull origin master
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[오류] git pull 실패 (DNS/네트워크 확인)"
            exit 1
        }
        Write-Host "[attend] git pull 완료"
    }
    finally {
        Pop-Location
    }
}
else {
    if (-not (Test-Path (Join-Path $Source "app.py"))) {
        Write-Host "[오류] 소스 없음: $Source"
        Write-Host "       PC 로컬 폴더 경로를 확인하세요."
        exit 1
    }
    Write-Host "[attend] 파일 복사: $Source -> $Target"
    & robocopy $Source $Target /E /XD .git __pycache__ /XF *.pyc /NFL /NDL /NJH /NJS | Out-Null
    if ($LASTEXITCODE -ge 8) {
        Write-Host "[오류] robocopy 실패"
        exit 1
    }
    Write-Host "[attend] 파일 복사 완료"
}

Write-Host "[attend] Docker 재시작 중..."
Push-Location $Target
try {
    docker compose up -d
    if ($LASTEXITCODE -ne 0) { throw "docker compose up 실패" }
    docker compose restart attend
    if ($LASTEXITCODE -ne 0) { throw "docker compose restart 실패" }
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "[attend] NAS 동기화 완료"
Write-Host "[attend] 확인: http://NAS주소:8102/api/status"
Write-Host ""
