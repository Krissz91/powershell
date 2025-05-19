#!/usr/bin/pwsh

Clear-Host

Write-Host "`nWelcome! IP address configuration begins..." -ForegroundColor Cyan

# Listing network adapters
Get-NetAdapter
Write-Host ""
Get-NetIPAddress
Write-Host ""

# Adapter Rename
$rename_old = Read-Host "What is the name of the network card? (E.g. Ethernet)"
$rename_new = Read-Host "What should be its new name?"
Rename-NetAdapter -Name $rename_old -NewName $rename_new
Write-Host "`nAdapter renamed: $rename_old -> $rename_new" -ForegroundColor Green

# IP address setting
$ipaddress = Read-Host "Enter the new IP address (E.g. 192.168.1.10)"
$DefaultGateway = Read-Host "Enter the default gateway. (E.g. 192.168.1.1)"
$PrefixLength = Read-Host "Enter the prefix (E.g. 24)"
$InterfaceIndex = Read-Host "Enter the InterfaceIndex number of the network card"

# Delete previous IPs (optional but useful)
Get-NetIPAddress -InterfaceIndex $InterfaceIndex -AddressFamily IPv4 | Remove-NetIPAddress -Confirm:$false

# Setting a new IP address
New-NetIPAddress -IPAddress $ipaddress -DefaultGateway $DefaultGateway -PrefixLength $PrefixLength -InterfaceIndex $InterfaceIndex
Write-Host "`nIP address set: $ipaddress /$PrefixLength, Gateway: $DefaultGateway" -ForegroundColor Green

# IPv6 disable – only if adapter name is specified
$disablename = Read-Host "If you want to disable IPv6, enter the name of the network card. (ENTER if not)"
if (![string]::IsNullOrWhiteSpace($disablename)) {
    Disable-NetAdapterBinding -Name $disablename -ComponentID ms_tcpip6
    Write-Host "`nIPv6 has been disabled on the '$disablename' adapter." -ForegroundColor Yellow
} else {
    Write-Host "IPv6 blocking omitted." -ForegroundColor DarkGray
}

# DNS setting – only if specified
$dnsaddress = Read-Host "If you want to set a DNS address, enter it (e.g. 8.8.8.8). If you have multiple addresses, separate them with a comma. (ENTER if not)"
if (![string]::IsNullOrWhiteSpace($dnsaddress)) {
    $dnsArray = $dnsaddress -split ",\s*"
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $dnsArray
    Write-Host "`nDNS address(es) set: $dnsaddress" -ForegroundColor Green
} else {
    Write-Host "DNS settings omitted." -ForegroundColor DarkGray
}

Write-Host "`nDone! It is recommended to run 'gpupdate /force' to update the settings." -ForegroundColor Cyan
