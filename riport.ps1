Clear-Host
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"			
$OutputFile = "System_Report_$Date.txt"

@"
===== SYSTEM REPORT =====
Generated on: $Date

=== System Information ===
"@ | Out-File $OutputFile

Get-ComputerInfo | Out-File -Append $OutputFile

@"
=== Uptime ===
"@ | Out-File -Append $OutputFile
(Get-Uptime).ToString() | Out-File -Append $OutputFile

@"
=== CPU and Memory ===
"@ | Out-File -Append $OutputFile
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Format-Table -AutoSize | Out-String | Out-File -Append $OutputFile
Get-CimInstance Win32_OperatingSystem | Select FreePhysicalMemory, TotalVisibleMemorySize | Out-File -Append $OutputFile

@"
=== Disk Usage ===
"@ | Out-File -Append $OutputFile
Get-Volume | Format-Table -AutoSize | Out-String | Out-File -Append $OutputFile

@"
=== Network Configuration ===
"@ | Out-File -Append $OutputFile
Get-NetIPAddress | Format-Table -AutoSize | Out-String | Out-File -Append $OutputFile
Get-NetTCPConnection | Where-Object { $_.State -eq "Established" } | Format-Table -AutoSize | Out-String | Out-File -Append $OutputFile

@"
=== Logged-in Users ===
"@ | Out-File -Append $OutputFile
quser | Out-File -Append $OutputFile

@"
=== Recent Security Logs ===
"@ | Out-File -Append $OutputFile
Get-EventLog -LogName Security -Newest 10 | Format-Table -AutoSize | Out-String | Out-File -Append $OutputFile

Write-Host "Report saved to: $OutputFile"
