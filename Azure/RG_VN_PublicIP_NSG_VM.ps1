#!/usr/bin/pwsh

New-AzResourceGroup -Name TEST-RG -Location northeurope -Force						

$virtualNetwork = New-AzVirtualNetwork -Name TEST-NET -ResourceGroupName TEST-RG -Location northeurope -AddressPrefix 10.10.0.0/16

$virtualNetwork | Add-AzVirtualNetworkSubnetConfig -Name TEST-NET-SUB1 -AddressPrefix 10.10.1.0/24

$virtualNetwork | Set-AzVirtualNetwork
	

$publicIP = New-AzPublicIpAddress -Name TEST-Public -ResourceGroupName TEST-RG -Location northeurope -AllocationMethod Static -Sku Standard


$vnet = Get-AzVirtualNetwork -Name TEST-NET -ResourceGroupName TEST-RG

$subnet = $vnet.Subnets | Where-Object {$_.Name -eq "TEST-NET-SUB1"}

$nic = New-AzNetworkInterface -Name TEST-NIC -ResourceGroupName TEST-RG -Location northeurope -SubnetId $subnet.Id -PublicIpAddressId $publicIP.Id


$nsg = New-AzNetworkSecurityGroup -Name TEST-NSG -ResourceGroupName TEST-RG -Location northeurope

$nsg | Add-AzNetworkSecurityRuleConfig -Name Allow-RDP -Protocol Tcp -Direction Inbound -Priority 1001 -Access Allow -SourceAddressPrefix "*" `
-SourcePortRange "*" -DestinationAddressPrefix "*" -DestinationPortRange 3389

$nsg | Set-AzNetworkSecurityGroup


Set-AzVirtualNetworkSubnetConfig -Name TEST-NET-SUB1 -AddressPrefix 10.10.1.0/24 -VirtualNetwork $vnet -NetworkSecurityGroup $nsg

$vnet | Set-AzVirtualNetwork

$vmConfig = New-AzVMConfig -VMName TEST-VM -VMSize Standard_DS1_v2

$vmConfig = Set-AzVMOperatingSystem -VM $vmConfig -Windows -ComputerName TEST-VM -Credential (Get-Credential) -ProvisionVMAgent -EnableAutoUpdate

User: addausername
Password for user azureadmin: ************

$vmConfig = Set-AzVMSourceImage -VM $vmConfig -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2022-datacenter -Version latest

$vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id

New-AzVM -VM $vmConfig -ResourceGroupName TEST-RG -Location northeurope

$nic = Get-AzNetworkInterface -Name TEST-NIC -ResourceGroupName TEST-RG

$nic.NetworkSecurityGroup = $nsg

$nic | Set-AzNetworkInterface
