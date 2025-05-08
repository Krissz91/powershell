#!/usr/bin/pwsh

Clear-Host

$name=Read-Host "Milyen neven hozzunk letre felhasznalot? (Pl. Minta Bela)"
$username=Read-Host "Adja meg a SamAccount nevet (Pl. MBela)"
$password=Read-Host "Jelszo:" -AsSecureString

$search = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

try {
if ($search) {Write-Host "A $name nevu felhasznalo mar a rendszerben van." -ForegroundColor Red -BackgroundColor Black}
else {New-ADUser -Name $name -SamAccountName $username -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false -Enabled $true}
        Write-Host "A $name nevu felhasznalot letrehoztuk." -ForegroundColor Green -BackgroundColor Black
}
catch {Write-Host "A felhasznalo letrehozasa kozben hiba tortent:$($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black}
