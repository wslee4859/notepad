# 메일 최종로그인 시간 추출
.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto





get-mailbox wslee4859 | select alias, @{label = "lastLogon";expression={(Get-MailboxStatistics $_).LastLogonTime}}

get-mailbox wslee4859 | fl

get-mailbox wslee4859 | Get-MailboxStatistics | select *size*, *Quota*
get-mailbox wslee4859 | Get-MailboxStatistics | select *Quota*

import-csv C:\file\180330_alias.csv | foreach-object {Get-Mailbox $_.alias | select alias, @{label = "lastLogon";expression={(Get-MailboxStatistics $_).LastLogonTime}}} | Export-Csv -Path "\\lcsekw3exch01\file\20180330LastTime.csv" -Encoding UTF8


"wslee4859","0819" | get-mailbox | select alias, display*, *create*, @{label = "enable"; expression={(Get-Aduser $_.name).Enabled}}


(Get-ADUser testid).enabled

get-mailbox "wslee4859","testid" | fl alias, display*, @{label = "enable"; expression={(Get-Aduser $_).Enabled}}

get-mailbox -Database mbxdb01 | select alias, display*, @{label = "enable"; expression={(Get-Aduser $_).Enabled}}

get-mailbox jeonggeolhan | select name, alias, display*, create*, when* , @{label = "enable";expression={(Get-Aduser $_.name).Enabled}}


get-mailbox -ResultSize unlimited -Filter {WindowsEmailAddress -like '*@lottechilsung.co.kr'} | Select-Object WindowsEmailAddress ,alias, display*, WhenMailboxCreated, WhenChanged, @{label = "enable"; expression={(Get-Aduser $_.name).Enabled}} | export-csv -Path "\\lcsekw3exch01\file\temp\20180502_MailboxAnalysis.csv" -Encoding UTF8


get-mailbox -Identity first6 | fl *sam* 

get-mailbox gmkim7s | fl WhenMailboxCreated 

#메일 사서함 용량할당량 / 사용량
Get-Mailbox  -ResultSize unlimited | select name, PrimarySMTPAddress, UseDatabaseQuotaDefaults, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, ProhibitSendQuota | ConvertTo-Csv > C:\file\wslee4859\Mailbox.csv  -NoTypeInformation

get-mailbox -ResultSize unlimited | select name, @{label=”lastlogonTime”;expression={(get-mailboxstatistics $_).LastLogonTime}}  | ConvertTo-Csv > C:\file\wslee4859\20201016_MailboxTime.csv  -NoTypeInformation

get-mailbox wslee4859 | select name, @{label=”lastlogonTime”;expression={(get-mailboxstatistics $_).LastLogonTime}}  | ConvertTo-Csv > C:\file\wslee4859\MailboxTime.csv  -NoTypeInformation


Get-MailboxStatistics wslee4859 | fl


import-csv {get-mailboxdatabase} 
