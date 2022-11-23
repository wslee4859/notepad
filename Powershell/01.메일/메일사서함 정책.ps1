.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


Get-OwaMailboxPolicy -identity wslee4859

get-mailbox -identity wslee4859 | select *
get-mailbox -identity mirim328 | select *policy*


Get-CASMailbox wslee4859 | select * 
Get-CASMailbox wslee4859 | select owaenabled 
SET-CASMailbox -identity wslee4859 -OWAEnabled $true

Get-CASMailbox wslee4859 | select ActiveSyncMailboxPolicy
Set-CASMailbox wslee4859 -owamailboxPolicy TEST
Set-CASMailbox wslee4859 -ActiveSyncMailboxPolicy TEST

#OWA 정책 
Get-OwaMailboxPolicy TEST | select *outlook*


Get-OutlookAnywhere

Get-ActiveSyncMailboxPolicy Default | select MaxAttachmentSize 


Get-ActiveSyncMailboxPolicy TEST | select AllowConsumerEmail 
set-ActiveSyncMailboxPolicy TEST -AllowConsumerEmail $true


GET-ActiveSyncOrganizationSettings

Get-MobileDeviceMailboxPolicy TEST
