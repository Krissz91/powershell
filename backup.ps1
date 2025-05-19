#!/usr/bin/pwsh

Clear-Host
# Author: Krisztian Toth
# Created: 07/05/2025
# Description: Interactive backup script in PowerShell

Write-Host "Üdv, $env:USERNAME!"
Write-Host "This is an interactive backup script in PowerShell."

# Source Request
$sourcePath = Read-Host "Please enter the full path to the file or folder you want to save."
if (-not (Test-Path $sourcePath)) {
    Write-Host "Error: The specified file or folder does not exist." -ForegroundColor Red
    exit 1
}

# Request target directory
$destinationDir = Read-Host "Please specify the destination directory for saving."
if (-not (Test-Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir | Out-Null
}

# Filename and timestamp
$itemName = Split-Path $sourcePath -Leaf
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = Join-Path $destinationDir "${itemName}_backup_$timestamp.zip"

# Archiving
Write-Host "Saving in progress..."
Compress-Archive -Path $sourcePath -DestinationPath $backupFile -Force

if (Test-Path $backupFile) {
    Write-Host "Save successful! Path: $backupFile" -ForegroundColor Green
} else {
    Write-Host "An error occurred while saving.." -ForegroundColor Red
}
