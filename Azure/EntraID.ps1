#!/usr/bin/pwsh

Connect-AzureAD

$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile

$passwordProfile.Password = "Jelszo123!"

New-AzureADUser -DisplayName "User Name" -PasswordProfile $passwordProfile -UserPrincipalName "un@usernameoutlook.onmicrosoft.com" `
-AccountEnabled $true -MailNickName "tesztuser"

$user = Get-AzureADUser -ObjectId un@usernameoutlook.onmicrosoft.com

$user.JobTitle = "System Administrator"

Set-AzureADUser -ObjectId un@usernameoutlook.onmicrosoft.com -JobTitle $user.JobTitle

New-AzureADGroup -DisplayName Administrators -MailEnabled $false -SecurityEnabled $true -MailNickName Admins

Set-AzureADGroup -ObjectId 3638de32-0a72-486c-9f10-0108050a5b7d -Description "Here are the system administrators"

Get-AzureADUser -ObjectId "un@usernameoutlook.onmicrosoft.com"

Add-AzureADGroupMember -ObjectId 3638de32-0a72-486c-9f10-0108050a5b7d -RefObjectId ee09ad1d-00e9-4f34-ae24-c6e08a810fac

Remove-AzureADGroupMember -ObjectId 3638de32-0a72-486c-9f10-0108050a5b7d -MemberId ee09ad1d-00e9-4f34-ae24-c6e08a810fac

Remove-AzureADGroup -ObjectId 3638de32-0a72-486c-9f10-0108050a5b7d

Remove-AzureADUser -ObjectId un@usernameoutlook.onmicrosoft.com
