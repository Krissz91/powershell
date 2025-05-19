#!/usr/bin/pwsh

Clear-Host

# Setting date and machine name
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$hostname = $env:COMPUTERNAME
$outputFile = "logs_${hostname}_${timestamp}.txt"

"Save Windows event log: $outputFile" | Out-File -FilePath $outputFile -Encoding utf8

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
        "`nError reading $log log: $_" | Out-File -Append -FilePath $outputFile -Encoding utf8
    }
}

Write-Host "`nLogs saved here: $outputFile"
