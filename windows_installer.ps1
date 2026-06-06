$dstFolder = "C:\axscheduler"
$taskName = "AXScheduler"

if (!(Test-Path $dstFolder)) {
    Write-Host "Creating folder $dstFolder..."
    New-Item -ItemType Directory -Path $dstFolder | Out-Null
}

Write-Host "Copying files..."
Copy-Item ".\main.py" "$dstFolder\main.py" -Force
Copy-Item ".\utils" "$dstFolder\utils" -Recurse -Force

Write-Host "Creating config file..."
$configPath = "$dstFolder\config.yaml"
if (!(Test-Path $configPath)) {
    "tasks:" | Out-File -Encoding utf8 $configPath
} else {
    Write-Host "Skipped due to existing config file detected."
}

Write-Host "Creating Python virtual environment..."
py -3 -m venv "$dstFolder\venv"

Write-Host "Installing dependencies..."
& "$dstFolder\venv\Scripts\pip.exe" install schedule pyyaml

Write-Host "Creating start.bat..."
@"
@echo off
cd /d $dstFolder
$dstFolder\venv\Scripts\python.exe $dstFolder\main.py
"@ | Out-File -Encoding ascii "$dstFolder\start.bat"

Write-Host "Registering Windows Task Scheduler task..."
schtasks /Create /TN $taskName /SC ONSTART /TR "$dstFolder\start.bat" /RL HIGHEST /F

Write-Host "Starting AXScheduler..."
schtasks /Run /TN $taskName

Write-Host "Done. AXScheduler is installed and running."
Write-Host "Config file: $dstFolder\config.yaml"