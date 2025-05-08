#!/usr/bin/pwsh

Clear-Host

Write-Host "A DHCP szerver telepitese es konfiguralasa kezdodik..." -ForegroundColor Yellow -BackgroundColor Black

$Name="Elso-DHCP"
$StartRange="192.168.10.100"
$EndRange="192.168.10.200"
$SubnetMask="255.255.255.0"
$DnsServer="192.168.10.1"
$Router="192.168.10.1"
$ScopeId="192.168.10.1"
$LeaseDuration="180.00:00:00"
$DnsName="Elso-DNS"
$IPAddress="192.168.10.1"

try {
Install-WindowsFeature -Name dhcp -IncludeManagementTools
Start-Service -Name DhcpServer
Add-DhcpServerv4Scope -Name $Name -StartRange $StartRange -EndRange $EndRange -SubnetMask $SubnetMask -State Active
Set-DhcpServerv4OptionValue -DnsServer $DnsServer -Router $Router -Force
Set-DhcpServerv4Scope -ScopeId $ScipeId -LeaseDuration $LeaseDuration
Add-DhcpServerInDC -DnsName $DnsName -IPAddress $IPAddress
Restart-Service -Name DhcpServer
Write-Host "A DHCP szerver telepitese es konfiguralasa rendben zajlott." -ForegroundColor Green -BackgroundColor Black
}
catch {Write-Host "A DHCP szerver telepitese es/vagy konfiguralasa kozben hiba tortent:$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black}

Write-Host "Az Active Directory telepitese es konfiguralasa kovetkezik." -ForegroundColor Yellow -BackgroundColor Black

try {
Install-WindowsFeature -Name ad-domain-service -IncludeManagementTools
Install-ADDSForest -DomainName ABC.LOCAL -DomainNetbiosName ABC -InstallDns
Write-Host "Az Active Directory telepitese es konfiguralasa rendben zajlott, hamarosan ujra indul a gep..." -ForegroundColor Green -BackgroundColor Black
}
catch {Write-Host "Az Active Directory telepitese es/vagy konfiguralasa kozben hiba tortent:$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black}
