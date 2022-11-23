Add-PSSnapin Microsoft.Exchange.Management.Powershell.E2010 -ErrorAction SilentlyContinue

Get-Mailbox -OrganizationalUnit "OU=����������,OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr" | Set-Mailbox -HiddenFromAddressListsEnabled $true


#���� ������ ���� ��ȸ
Get-Mailbox -OrganizationalUnit "OU=����������,OU=JJ,OU=groups,OU=ekw,DC=lottechilsung,DC=co,DC=kr" | Where-Object {$_.HiddenFromAddressListsEnabled -eq '' } | fl name,displayname, DistinguishedName, HiddenFromAddressListsEnabled

#�ַ� ������ ���� ��ȸ
Get-Mailbox -OrganizationalUnit "OU=����������,OU=Members,OU=lottebeverage,DC=lottechilsung,DC=co,DC=kr" | Where-Object {$_.HiddenFromAddressListsEnabled -eq '' } | fl name,displayname, DistinguishedName, HiddenFromAddressListsEnabled

Get-Mailbox smartksj | fl *


get-mailbox gunny | fl HiddenFromAddressListsEnabled

get-mailbox gunny | set-mailbox -HiddenFromAddressListsEnabled $true -WhatIf

Set-UserPhoto gildongkim -PictureData ([System.IO.File]::ReadAllBytes("C:\20143037_1.jpg"))

