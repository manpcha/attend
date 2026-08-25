# Build docker image on PC and copy to NAS share
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "attend: docker build on PC..."
docker build -t attend:latest .
if ($LASTEXITCODE -ne 0) { throw "docker build failed" }

Write-Host "attend: save attend-image.tar"
docker save attend:latest -o attend-image.tar
if ($LASTEXITCODE -ne 0) { throw "docker save failed" }

Write-Host ""
Write-Host "attend: copy to T:\"
robocopy $PSScriptRoot T:\ attend-image.tar docker-compose.nas.yml /NFL /NDL /NJH /NJS | Out-Null

Write-Host ""
Write-Host "attend: done"
Write-Host "NEXT on NAS SSH:"
Write-Host "  cd /volume1/docker/attend"
Write-Host "  docker load -i attend-image.tar"
Write-Host "  docker compose -f docker-compose.nas.yml up -d"
Write-Host "  curl -s http://127.0.0.1:8102/api/status"
Write-Host ""
