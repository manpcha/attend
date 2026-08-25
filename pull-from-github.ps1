# Download latest files from GitHub (no git required)
param(
    [string]$Target = "D:\mine\apps\attend"
)

$ErrorActionPreference = "Stop"

if (-not $Target.EndsWith("\")) { $Target += "\" }

$base = "https://raw.githubusercontent.com/manpcha/attend/master"
$files = @(
    "index.html", "app.py", "Dockerfile", "docker-compose.yml", "requirements.txt",
    "run-local.bat", "run-local.ps1",
    "sync-to-nas.bat", "sync-to-nas.ps1", "sync-to-nas.cmd",
    "pull-from-github.bat", "pull-from-github.ps1", "update-nas.bat",
    "restart-nas-docker.bat"
)

Write-Host ""
Write-Host "attend: GitHub -> $Target"
Write-Host ""

foreach ($f in $files) {
    Write-Host "  download: $f"
    Invoke-WebRequest -Uri "$base/$f" -OutFile (Join-Path $Target $f) -UseBasicParsing
}

Write-Host ""
<<<<<<< Updated upstream
Write-Host "[attend] done (data folder unchanged)"
=======
Write-Host "attend: done (data folder unchanged)"
>>>>>>> Stashed changes
Write-Host ""
