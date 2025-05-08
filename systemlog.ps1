#!/usr/bin/pwsh

Clear-Host

# Dátum és gépnév beállítása
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$hostname = $env:COMPUTERNAME
$outputFile = "logs_${hostname}_${timestamp}.txt"

"Windows eseménynaplók mentése: $outputFile" | Out-File -FilePath $outputFile -Encoding utf8

$logs = @("Application", "System", "Security", "Setup")

foreach ($log in $logs) {
    try {
        "`n===== $log Log =====`n" | Out-File -Append -FilePath $outputFile -Encoding utf8
        Get-EventLog -LogName $log -Newest 100 | Out-File -Append -FilePath $outputFile -Encoding utf8
    } catch {
        "`n[!] Hiba a(z) $log log olvasásakor: $_" | Out-File -Append -FilePath $outputFile -Encoding utf8
    }
}

Write-Output "`n✅ Logok mentve ide: $outputFile"
