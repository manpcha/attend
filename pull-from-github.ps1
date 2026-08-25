# UTF-8 GitHub download script (PC local, no git required)
param(
    [string]$Target = "D:\mine\apps\attend"
)

$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()
$ErrorActionPreference = "Stop"

if (-not $Target.EndsWith("\")) { $Target += "\" }

$base = "https://raw.githubusercontent.com/manpcha/attend/master"
$files = @(
    "index.html", "app.py", "Dockerfile", "docker-compose.yml", "requirements.txt",
    "run-local.bat", "sync-to-nas.bat", "sync-to-nas.ps1",
    "pull-from-github.bat", "pull-from-github.ps1", "update-nas.bat"
)

Write-Host ""
Write-Host "[attend] GitHub -> $Target"
Write-Host ""

foreach ($f in $files) {
    Write-Host "  다운로드: $f"
    Invoke-WebRequest -Uri "$base/$f" -OutFile (Join-Path $Target $f) -UseBasicParsing
}

Write-Host ""
Write-Host "[attend] 완료 (data 폴더는 유지됨)"
Write-Host ""
