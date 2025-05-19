#!/usr/bin/pwsh

Clear-Host

Write-Host "The installation and configuration of the DHCP server is starting..." -ForegroundColor Yellow -BackgroundColor Black
Write-Host "(You will give dhcp/ad error message, but don't worry it will be working.)" -ForegroundColor Yellow -BackgroundColor Black

# DHCP input parameters
$Name = Read-Host "What name should we give to the DHCP scope? (e.g. First-DHCP)"
$StartRange = Read-Host "What should be the start IP address of the range? (e.g. 192.168.10.100)"
$EndRange = Read-Host "What should be the end IP address of the range? (e.g. 192.168.10.200)"
$SubnetMask = Read-Host "What should be the subnet mask? (e.g. 255.255.255.0)"
$DnsServer = Read-Host "What is the IP address of the DNS server? (e.g. 192.168.10.1)"
$Router = Read-Host "What is the default gateway IP address? (e.g. 192.168.10.1)"
$ScopeId = Read-Host "What is the network address (Scope ID)? (e.g. 192.168.10.1)"
$LeaseDuration = Read-Host "What should be the lease duration? (format: days.hours:minutes:seconds, e.g. 180.00:00:00)"
$DnsName = Read-Host "What should the DNS name be? (e.g. First-DNS)"
$IPAddress = Read-Host "What is the IP address of the DNS server? (e.g. 192.168.10.1)"

# DHCP configuration
try {
    Install-WindowsFeature -Name DHCP -IncludeManagementTools
    Start-Service -Name DhcpServer
    Add-DhcpServerv4Scope -Name $Name -StartRange $StartRange -EndRange $EndRange -SubnetMask $SubnetMask -State Active
    Set-DhcpServerv4OptionValue -DnsServer $DnsServer -Router $Router -Force
    Set-DhcpServerv4Scope -ScopeId $ScopeId -LeaseDuration ([TimeSpan]::Parse($LeaseDuration))
    Add-DhcpServerInDC -DnsName $DnsName -IPAddress $IPAddress
    Restart-Service -Name DhcpServer
    Write-Host "The DHCP server was installed and configured successfully." -ForegroundColor Green -BackgroundColor Black
}
catch {
    Write-Host "An error occurred while installing and/or configuring the DHCP server: $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black
}

Write-Host "The installation and configuration of Active Directory is starting..." -ForegroundColor Yellow -BackgroundColor Black

# AD input parameters
$DomainName = Read-Host "What should the domain name be? (e.g. office.local)"
$DomainNetbiosName = Read-Host "What should the NetBIOS name of the domain be? (e.g. OFFICE)"

# AD configuration
try {
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -InstallDns -Force
    Write-Host "Active Directory was installed and configured successfully. The system will restart shortly..." -ForegroundColor Green -BackgroundColor Black
}
catch {
    Write-Host "An error occurred while installing and/or configuring Active Directory: $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black
}
