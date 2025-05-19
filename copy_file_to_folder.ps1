#!/usr/bin/pwsh

Clear-Host

$filepath=Read-Host "Which file should we copy? Enter the full path (e.g. C:\Users\Username\file)"
$folderpath=Read-Host "Which folder should we copy it to? Enter the full path (e.g. C:\Users\Administrator\folder)"

Start-Sleep -Seconds 2

if (Test-Path $filepath) {Write-Host "The file is on the machine." -ForegroundColor Yellow -BackgroundColor Black}
else {Write-Host "The file is not on the machine, but I will create an empty..." -ForegroundColor Red -BackgroundColor Black
        New-Item -Path $filepath -ItemType File | Out-Null}

Start-Sleep -Seconds 2

if (Test-Path $folderpath) {Write-Host "The folder is on the machine." -ForegroundColor Yellow -BackgroundColor Black}
else {Write-Host "The folder is not on the machine, but we are creating one..." -ForegroundColor Red -BackgroundColor Black
        New-Item -Path $folderpath -ItemType Directory | Out-Null}

Start-Sleep -Seconds 2

try {Copy-Item -Path $filepath -Destination $folderpath -Force
        Write-Host "The copying of the file went smoothly." -ForegroundColor Green -BackgroundColor Black}
catch {Write-Host "An error occurred while copying the file: $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black}
