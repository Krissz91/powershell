#!/usr/bin/pwsh

Clear-Host

# Datum es gepnev beallitasa
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$hostname = $env:COMPUTERNAME
$outputFile = "logs_${hostname}_${timestamp}.txt"

"Windows esemenynaplok mentese: $outputFile" | Out-File -FilePath $outputFile -Encoding utf8

$logs = @("Application", "System", "Security", "Setup")

foreach ($log in $logs) {
    try {
        "`n===== $log Log =====`n" | Out-File -Append -FilePath $outputFile -Encoding utf8
        if ($log -eq "Setup") {
            Get-WinEvent -LogName $log -MaxEvents 100 | Out-File -Append -FilePath $outputFile -Encoding utf8
        } else {
            Get-EventLog -LogName $log -Newest 100 | Out-File -Append -FilePath $outputFile -Encoding utf8
        }
    } catch {
        "`n[!] Hiba a(z) $log log olvasasakor: $_" | Out-File -Append -FilePath $outputFile -Encoding utf8
    }
}

Write-Host "`n Lokok mentve ide: $outputFile"
