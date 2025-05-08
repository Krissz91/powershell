Clear-Host
# Author: Krisztian Toth
# Created: 07/05/2025
# Description: Interactive backup script in PowerShell

Write-Host "Üdv, $env:USERNAME!"
Write-Host "Ez egy interaktív mentési script PowerShell-ben."

# Forrás bekérése
$sourcePath = Read-Host "Kérem, adja meg a mentendő fájl vagy mappa teljes elérési útját"
if (-not (Test-Path $sourcePath)) {
    Write-Host "Hiba: A megadott fájl vagy mappa nem létezik." -ForegroundColor Red
    exit 1
}

# Célkönyvtár bekérése
$destinationDir = Read-Host "Kérem, adja meg a cél könyvtárat a mentéshez"
if (-not (Test-Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir | Out-Null
}

# Fájlnév és időbélyeg
$itemName = Split-Path $sourcePath -Leaf
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = Join-Path $destinationDir "${itemName}_backup_$timestamp.zip"

# Archiválás
Write-Host "Mentés folyamatban..."
Compress-Archive -Path $sourcePath -DestinationPath $backupFile -Force

if (Test-Path $backupFile) {
    Write-Host "Mentés sikeres! Elérési út: $backupFile" -ForegroundColor Green
} else {
    Write-Host "Hiba történt a mentés során." -ForegroundColor Red
}
