param(
    [string]$Target = "T:\"
)

$ErrorActionPreference = "Stop"
$baseUrl = "https://raw.githubusercontent.com/manpcha/attend/master"

if (-not $Target.EndsWith("\")) { $Target += "\" }

if (-not (Test-Path (Join-Path $Target "docker-compose.yml"))) {
    Write-Error "docker-compose.yml 을 찾을 수 없습니다: $Target"
}

$files = @("index.html", "app.py", "Dockerfile", "docker-compose.yml", "requirements.txt")
foreach ($file in $files) {
    $dest = Join-Path $Target $file
    Write-Host "[attend] $file 다운로드..."
    Invoke-WebRequest -Uri "$baseUrl/$file" -OutFile $dest -UseBasicParsing
}

Write-Host "[attend] 파일 다운로드 완료"
