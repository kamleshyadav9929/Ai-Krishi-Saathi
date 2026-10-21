# AI Krishi Saathi — Development Run Script
# Loads API keys from dart_defines.json and runs the Flutter app
# Usage: .\scripts\run_dev.ps1 [device_id]

$ErrorActionPreference = "Stop"

$definesFile = Join-Path $PSScriptRoot "..\dart_defines.json"

if (-not (Test-Path $definesFile)) {
    Write-Host "ERROR: dart_defines.json not found!" -ForegroundColor Red
    Write-Host "Copy dart_defines.template.json to dart_defines.json and add your API keys." -ForegroundColor Yellow
    exit 1
}

Write-Host "Starting AI Krishi Saathi with API keys from dart_defines.json..." -ForegroundColor Green

$flutterArgs = @("run", "--dart-define-from-file=$definesFile")

if ($args.Count -gt 0) {
    $flutterArgs += @("-d", $args[0])
}

flutter @flutterArgs
