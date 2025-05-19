#!/usr/bin/pwsh

# 1. Request user data
$gpoName = Read-Host "Enter the name of the GPO to be created. (e.g. HR_Folder)"
$ouDn = Read-Host "Enter the OU Distinguished Name (e.g. OU=HR,DC=office,DC=local)"
$driveLetter = Read-Host "Enter the drive letter. (e.g. Y:)"
$sharePath = Read-Host "Enter the UNC path of the network share (e.g. \\Winser19dc1\hr)"
$groupName = Read-Host "Enter the group name (or leave blank if no filtering is required)"
$domain = Read-Host "Enter the domain name (e.g. office.local)"

# 2. Create a GPO
$gpo = New-GPO -Name $gpoName

# 3. Linking and forcing
New-GPLink -Name $gpoName -Target $ouDn
Set-GPLink -Name $gpoName -Target $ouDn -Enforced Yes

# 4. Conditional generation of filter section
if ([string]::IsNullOrWhiteSpace($groupName)) {
    $filterXml = ""
} else {
    $filterXml = @"
    <Filters>
      <FilterGroup name="$groupName" userContext="1" />
    </Filters>
"@
}

# 5. Generate XML file
$xml = @"
<?xml version="1.0" encoding="utf-8"?>
<DriveMaps clsid="{5794DAFD-BE60-433f-88A2-1A31939AC01F}">
  <DriveMap clsid="{8A28E2C5-8D06-49A4-AE46-5A3FD2D92D93}" name="$driveLetter" status="Update" uid="{D45E4642-B37B-48EF-B004-112233445566}">
    <Properties action="U" thisDrive="$driveLetter" useLetter="1" path="$sharePath" reconnect="1" label="$gpoName Drive" />
$filterXml  </DriveMap>
</DriveMaps>
"@

# 6. Placing Preferences XML
$gpoId = $gpo.Id
$gpoPath = "\\$env:COMPUTERNAME\SYSVOL\$domain\Policies\{$gpoId}\User\Preferences\Drives"
New-Item -ItemType Directory -Force -Path $gpoPath
$xml | Set-Content -Path "$gpoPath\Drivemaps.xml" -Encoding UTF8

# 7. Update policy
gpupdate /force
