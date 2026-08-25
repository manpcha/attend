# Copy PC files to NAS network share (T:). Docker runs on NAS, not on T:.
param(
    [string]$Source = "D:\mine\apps\attend",
    [string]$Target = "T:\"
)

$ErrorActionPreference = "Stop"

if (-not $Target.EndsWith("\")) { $Target += "\" }
if (-not $Source.EndsWith("\")) { $Source += "\" }

Write-Host ""
Write-Host "attend: copy $Source -> $Target"
Write-Host ""

if (-not (Test-Path (Join-Path $Target "docker-compose.yml"))) {
    Write-Host "ERROR: docker-compose.yml not found on $Target"
    Write-Host "       map T: to \\dandycha\docker\attend"
    exit 1
}

if (-not (Test-Path (Join-Path $Source "app.py"))) {
    Write-Host "ERROR: source not found: $Source"
    exit 1
}

& robocopy $Source $Target /E /XD .git __pycache__ data /XF *.pyc /NFL /NDL /NJH /NJS | Out-Null
if ($LASTEXITCODE -ge 8) {
    Write-Host "ERROR: robocopy failed"
    exit 1
}

Write-Host "attend: copy OK"
Write-Host ""
Write-Host "NEXT: restart docker ON THE NAS"
Write-Host "  DSM Container Manager - restart attend"
Write-Host "  or run: restart-nas-docker.bat"
Write-Host ""
