Add-PSSnapin Microsoft.Exchange.Management.Powershell.E2010 -ErrorAction SilentlyContinue


Import-Csv C:\file\shUserList.csv | ForEach-Object {Get-MailboxStatistics $_.name | Select-Object legacyDN,LastLogonTime,TotalItemSize} | export-csv -path c:\file\shUserListMail.csv -Encoding UTF8


Get-MailboxStatistics wslee4859 | fl disconnect

Get-MailboxStatistics wslee4859 | fl *id*