#!/usr/bin/pwsh

Clear-Host
# Author: Krisztian Toth
# Created: 02/07/2025
# Description: Interactive backup script in Powershell

Write-Host "Greeting, $env:USERNAME!"
Write-Host "This is an interactive backup script in Powershell."

# Source Request
$sourcePath = Read-Host "Please enter the full path to the file or folder you want to save."
if (Test-Path $sourcePath) {Write-Host "The source path is avaiable..." -ForegroundColor Yellow -BackgroundColor Black}
else {Write-Host "Error: The specified file or folder does not exist." -ForegroundColor Red -BackgroundColor Black
      exit 1}

# Request target directory
$destinationDir = Read-Host "Please specify the destination directory for saving."
if (Test-Path $destinationDir) {Write-Host "The directory is exist..." -ForegroundColor Yellow -BackgroundColor Black}
else {Write-Host "The directory is not exist, but we are creating one..." -ForegroundColor Red -BackgroundColor Black
        New-Item -Path $destinationDir -ItemType Directory | Out-Null}

# Filename and timestamp
$itemName = Split-Path $sourcePath -Leaf
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-ss"
$backupFile = Join-Path $destinationDir "${itemName}_backup_$timestamp.zip"

# Archiving
Write-Host "Saving in progress..."
Compress-Archive -Path $sourcePath -DestinationPath $backupFile -Force

if (Test-Path $backupFile) {Write-Host "Save successful! Path: $backupFile" -ForegroundColor Green -BackgroundColor Black}
else {Write-Host "An error occurred while saving..." -ForegroundColor Red -BackgroundColor Black}
