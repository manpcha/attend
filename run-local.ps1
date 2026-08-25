# Start local attend server
param(
    [string]$Root = $PSScriptRoot
)

if (-not $Root.EndsWith("\")) { $Root += "\" }
$dataDir = Join-Path $Root "data"
if (-not (Test-Path $dataDir)) { New-Item -ItemType Directory -Path $dataDir | Out-Null }

$env:DATA_DIR = $dataDir

Write-Host ""
Write-Host "========================================"
Write-Host " attend local server"
Write-Host " DATA_DIR=$dataDir"
Write-Host " open:  http://127.0.0.1:8102"
Write-Host " status: http://127.0.0.1:8102/api/status"
Write-Host " (use http not https)"
Write-Host "========================================"
Write-Host ""

Set-Location $Root

try {
    python -c "import uvicorn" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "attend: installing packages..."
        python -m pip install -r requirements.txt
    }
}
catch {
    Write-Host "ERROR: python/uvicorn not available"
    exit 1
}

Write-Host "attend: starting server... keep this window open."
Write-Host ""
python -m uvicorn app:app --host 127.0.0.1 --port 8102
