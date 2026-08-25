# Sync PC local folder or NAS git -> NAS docker folder
param(
    [string]$Source = "D:\mine\apps\attend",
    [string]$Target = "T:\"
)

$ErrorActionPreference = "Stop"

if (-not $Target.EndsWith("\")) { $Target += "\" }
if (-not $Source.EndsWith("\")) { $Source += "\" }

Write-Host ""
Write-Host "========================================"
Write-Host " attend NAS sync"
Write-Host " target: $Target"
Write-Host "========================================"
Write-Host ""

if (-not (Test-Path (Join-Path $Target "docker-compose.yml"))) {
    Write-Host "ERROR: docker-compose.yml not found: $Target"
    Write-Host "       check T: drive (\\dandycha\docker\attend)"
    exit 1
}

$gitDir = Join-Path $Target ".git"
if (Test-Path $gitDir) {
    Write-Host "attend: git repo found -> git pull"
    Push-Location $Target
    try {
        git pull origin master
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: git pull failed (check DNS/network)"
            exit 1
        }
        Write-Host "attend: git pull OK"
    }
    finally {
        Pop-Location
    }
}
else {
    if (-not (Test-Path (Join-Path $Source "app.py"))) {
        Write-Host "ERROR: source not found: $Source"
        exit 1
    }
    Write-Host "attend: copy files $Source -> $Target"
    & robocopy $Source $Target /E /XD .git __pycache__ /XF *.pyc /NFL /NDL /NJH /NJS | Out-Null
    if ($LASTEXITCODE -ge 8) {
        Write-Host "ERROR: robocopy failed"
        exit 1
    }
    Write-Host "attend: copy OK"
}

Write-Host "attend: restarting docker..."
Push-Location $Target
try {
    docker compose up -d
    if ($LASTEXITCODE -ne 0) { throw "docker compose up failed" }
    docker compose restart attend
    if ($LASTEXITCODE -ne 0) { throw "docker compose restart failed" }
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "attend: NAS sync done"
Write-Host "attend: check http://NAS-IP:8102/api/status"
Write-Host ""
