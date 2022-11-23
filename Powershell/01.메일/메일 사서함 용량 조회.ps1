Add-PSSnapin Microsoft.Exchange.Management.Powershell.E2010 -ErrorAction SilentlyContinue


Get-Mailbox -OrganizationalUnit "ou=운영담당,ou=전산팀,ou=기획부문,ou=지원,ou=롯데칠성음료(주),ou=JJ,ou=Groups,ou=eKW,dc=lottechilsung,dc=co,dc=kr" -ResultSize Unlimited | select DisplayName,PrimarySMTPAddress,ProhibitSendQuota,@{label=”TotalItemSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}

Get-Mailbox -OrganizationalUnit "ou=Members,ou=LotteBeverage,dc=lottechilsung.dc=co,dc=kr" -ResultSize Unlimited | select Name

# 사용자별 사서함 UseDataBaseQuotaDefaults(True : 300M(정책), False : 개별 용량) 및 량 (TotalItemSize) 사서함 사용량, (ProhibitSendQuota) 사서함 할당
Get-Mailbox wslee4859 | select name, PrimarySMTPAddress, UseDatabaseQuotaDefaults, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, ProhibitSendQuota

Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize Unlimited | select name, PrimarySMTPAddress, UseDatabaseQuotaDefaults, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, ProhibitSendQuota | export-csv -Path "\\lcsekw3exch01\file\temp\20170620_LiqMailboxSize.csv" -Encoding UTF8



# 위 버전에서 AD 사용여부 확인 
Get-Mailbox wslee4859 | select name, PrimarySMTPAddress, UseDatabaseQuotaDefaults, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, ProhibitSendQuota, @{label="Status"; expression={(Get-ADUser $_.name).Enabled}} 

Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" -ResultSize Unlimited | select name, PrimarySMTPAddress, UseDatabaseQuotaDefaults, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, ProhibitSendQuota, @{label="Status"; expression={(Get-ADUser $_.name).Enabled}}  | export-csv -Path "\\lcsekw3exch01\file\temp\20170620_LiqMailboxSizeVer2.csv" -Encoding UTF8

    # 전체사용자 조회 
Get-Mailbox -ResultSize Unlimited | select name, PrimarySMTPAddress, UseDatabaseQuotaDefaults, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, ProhibitSendQuota, @{label="Status"; expression={(Get-ADUser $_.name).Enabled}}  | export-csv -Path "C:\20210526_mailbox.csv" -Encoding UTF8

    
#주류 도메인 사람 중에서 조회 
Get-Mailbox -ResultSize Unlimited -Filter {WindowsEmailAddress -like '*@lotteliquor.com'} | select name, PrimarySmtpAddress, UseDatabaseQuotaDefaults, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToMB()}}, ProhibitSendQuota, @{label="Status"; expression={(Get-ADUser $_.name).Enabled}}  | export-csv -Path "\\lcsekw3exch01\file\temp\20170620_LiqMailboxSizeVer5.csv" -Encoding UTF8



#AD가 true 인 살아있는 사용자의 메일 사서함 용량 조회 (너무오래걸림)
Get-ADUser -Filter 'Enabled -eq "true"' | select Name, @{label=”PrimarySMTPAddress”;expression={(get-mailbox $_.Name).PrimarySMTPAddress}}, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_.SamAccountName).TotalItemSize}},  @{label=”ProhibitSendQuota”;expression={(get-mailbox $_.Name).ProhibitSendQuota}}, @{label=”UseDatabaseQuotaDefaults”;expression={(get-mailbox $_.Name).UseDatabaseQuotaDefaults}} | export-csv -Path "C:\20210526_mailbox.csv" -Encoding UTF8

Get- -Filter 'Enabled -eq "true"' | select Name, @{label=”PrimarySMTPAddress”;expression={(get-mailbox $_.Name).PrimarySMTPAddress}}, @{label=”TotalSize(MB)”;expression={(get-mailboxstatistics $_.SamAccountName).TotalItemSize}},  @{label=”ProhibitSendQuota”;expression={(get-mailbox $_.Name).ProhibitSendQuota}}, @{label=”UseDatabaseQuotaDefaults”;expression={(get-mailbox $_.Name).UseDatabaseQuotaDefaults}} | export-csv -Path "C:\Temp\20201106_mailbox.csv" -Encoding UTF8

Get-MailboxStatistics -Filter "ou=퇴직자조직,ou=JJ,ou=Groups,ou=eKW,dc=lottechilsung,dc=co,dc=kr" | select displayName, totalItemSize

get-mailbox jeonggeolhan | fl UseDataBaseQuotaDefaults

get-content 

Get-MailboxFolderStatistics -IncludeAnalysis -FolderScope All | Where-Object {(($_.TopSubjectSize -Match "MB") -and ($_.TopSubjectSize -GE 5.0)) -or ($_.TopSubjectSize -Match "GB")} | Select-Object Identity, TopSubject, TopSubjectSize | Export-CSV -path "C:\gunItemList.csv" -notype

Get-Mailbox -ResultSize 100 | Search-Mailbox -SearchQuery {Size:>5MB AND from:"gun.lee@lottechilsung.co.kr"} -TargetMailbox mail13 -TargetFolder TestGun -LogOnly -LogLevel Full

Get-Mailbox -identity wslee4859 -ResultSize 100 | Get-MailboxFolderStatistics -IncludeAnalysis -FolderScope All | Where-Object {(($_.TopSubjectSize -Match "MB") -and ($_.TopSubjectSize -GE 5.0)) -or ($_.TopSubjectSize -Match "GB")} | Select-Object Identity, TopSubject, TopSubjectSize | Export-CSV -Encoding UTF8 -path "C:\gunreportItem.csv" -notype

Get-mailbox -Identity jeonggeolhan -resultsize unlimited | Get-MailboxFolderStatistics -IncludeAnalysis | where-Object { $_.topSubjectSize -gt 5MB } | select identity,itemsinfolder,TopSubject,TopSubjectSize,topsubjectCount,topsubjectPath | Export-Csv -Encoding UTF8 C:\5mb.csv

Get-mailbox -Identity gun.lee -resultsize unlimited |select all | Get-MailboxFolderStatistics Export-Csv -Encoding UTF8 C:\5mb.csv

Get-mailbox -Identity jeonggeolhan

Get-Mailbox -Identity wslee4859 -ResultSize Unlimited | Get-MailboxFolderStatistics -IncludeAnalysis -FolderScope All | Where-Object {(($_.TopSubjectSize -Match "MB") -and ($_.TopSubjectSize -Gt 0.1mb)) -or ($_.TopSubjectSize -Match "GB")} | Select-Object Identity, TopSubject, TopSubjectSize, DisplayName | Export-CSV -Encoding UTF8  -path "C:\gunreport5mb.csv" -notype

Get-Mailbox -Identity wslee4859 -ResultSize Unlimited | Get-MailboxFolderStatistics -IncludeAnalysis -FolderScope All | Where-Object {(($_.TopSubjectSize -Match "MB") -and ($_.TopSubjectSize -GE 15)) -or ($_.TopSubjectSize -Match "GB")} | Select-Object Identity, TopSubject, TopSubjectSize | Export-CSV -Encoding UTF8  -path "C:\이건테스.csv" -notype

Get-MailboxFolderStatistics -Identity wslee4859 -includeanalysis -FolderScope All | Sort-Object TopSubjectSize -Descending  | Select-Object TopSubjectSize,name,itemsinfolder,TopSubject,topsubjectCount,topsubjectPath |  Export-CSV -Encoding UTF8  -path "C:\이건테스.csv" -notype
