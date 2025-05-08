#!/usr/bin/pwsh
Clear-Host

$filepath=Read-Host "Melyik allomanyt masoljuk? Teljes utvonalat adja meg (Pl. C:\Users\Username\file)"	
$folderpath=Read-Host "Melyik mappaba masoljuk? Teljes utvonalat adja meg (Pl. C:\Users\Administrator\folder)"

Start-Sleep -Seconds 2

if (Test-Path $filepath) {Write-Host "Az allomany a gepen van." -ForegroundColor Yellow -BackgroundColor Black}
else {Write-Host "Az allomany nincs a gepen, de kezitunk egy ureset..." -ForegroundColor Red -BackgroundColor Black
        New-Item -Path $filepath -ItemType File | Out-Null}

Start-Sleep -Seconds 2

if (Test-Path $folderpath) {Write-Host "A mappa a gepen van." -ForegroundColor Yellow -BackgroundColor Black}
else {Write-Host "A mappa nincs a gepen, de keszitunk egyet..." -ForegroundColor Red -BackgroundColor Black
        New-Item -Path $folderpath -ItemType Directory | Out-Null}

Start-Sleep -Seconds 2

try {Copy-Item -Path $filepath -Destination $folderpath -Force
        Write-Host "Az allomany masolasa rendben zajlott." -ForegroundColor Green -BackgroundColor Black}
catch {Write-Host "Az allomany masolasa kozben hiba tortent: $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black}
