
.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto

Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery 'subject:"자전거 투어 행사"' -TargetMailbox mail11 -TargetFolder "Spam1"


Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery 'subject:"불꽃 축제 무료 입장권"' -DeleteContent
Get-Mailbox -OrganizationalUnit "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -ResultSize unlimited | Search-Mailbox -SearchQuery 'subject:"고궁 야간 개장 관람 이벤트"' -DeleteContent