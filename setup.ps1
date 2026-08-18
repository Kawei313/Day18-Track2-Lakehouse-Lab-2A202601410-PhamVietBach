<#
.SYNOPSIS
Sets up and runs the lightweight Day 18 lab on Windows.

.DESCRIPTION
The Makefile uses POSIX paths such as .venv/bin/python.  This script uses
Windows-native PowerShell paths and avoids Docker/JVM for the default lab path.

.EXAMPLE
.\setup.ps1 -Action all
.\setup.ps1 -Action run-all
#>
[CmdletBinding()]
param(
    [ValidateSet('setup', 'smoke', 'data', 'data-ai', 'test', 'run-all', 'lab', 'all')]
    [string]$Action = 'all'
)

$ErrorActionPreference = 'Stop'
$env:PYTHONIOENCODING = 'utf-8'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root
$Python = Join-Path $Root '.venv\Scripts\python.exe'

function Initialize-Lab {
    if (-not (Test-Path $Python)) {
        py -3 -m venv .venv
    }
    & $Python -m pip install --upgrade pip
    & $Python -m pip install -r requirements.txt
    & $Python -m jupytext --to notebook --update notebooks\*.py
}

function Invoke-Lab([string]$Script) {
    & $Python $Script
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if ($Action -in @('setup', 'all')) { Initialize-Lab }
if ($Action -in @('smoke', 'all')) { Invoke-Lab 'scripts\verify_lite.py' }
if ($Action -in @('data', 'all')) { Invoke-Lab 'scripts\generate_data_lite.py' }
if ($Action -in @('data-ai', 'all')) { Invoke-Lab 'scripts\generate_ai_data.py' }
if ($Action -in @('test', 'all')) {
    & $Python -m pytest -q
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
if ($Action -in @('run-all', 'all')) { Invoke-Lab 'scripts\run_all.py' }
if ($Action -eq 'lab') {
    & $Python -m jupyter lab --notebook-dir=notebooks --ServerApp.token='' --no-browser
}
