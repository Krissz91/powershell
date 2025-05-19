#!/usr/bin/pwsh

Clear-Host

$name=Read-Host "What name should we use to create a user? (e.g. Bill Gates)"
$username=Read-Host "Enter the Sam Account name (Pl. BGates)"
$password=Read-Host "Password:" -AsSecureString

$search = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

try {
if ($search) {Write-Host "The name $name already exists in the system." -ForegroundColor Red -BackgroundColor Black
		exit 1}
else {New-ADUser -Name $name -SamAccountName $username -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -Enabled $true}
        Write-Host "The user named $name has been created." -ForegroundColor Green -BackgroundColor Black
}
catch {Write-Host "An error occurred while creating the user.:$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black}
