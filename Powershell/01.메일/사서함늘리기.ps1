# 메일 사서함 용량 예외 설정 IssueWarningQuota : 보내기 금지, ProhibitSendQuota : 보내기 및 받기 금지, ProhibitSendReceiveQuota : 사서함에 대한 할당

Set-Mailbox -Identity "20070131" -IssueWarningQuota 450mb -ProhibitSendQuota 500mb -ProhibitSendReceiveQuota 512mb -UseDatabaseQuotaDefaults $false -WhatIf


# OU 단위 메일 사서함 용량 예외 설정 IssueWarningQuota : 보내기 금지, ProhibitSendQuota : 보내기 및 받기 금지, ProhibitSendReceiveQuota : 사서함에 대한 할당
Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr"  | Set-Mailbox -IssueWarningQuota 250mb -ProhibitSendQuota 300mb -ProhibitSendReceiveQuota 320mb -UseDatabaseQuotaDefaults $false -WhatIf
Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" | Set-Mailbox -UseDatabeQuotaDefaults $true

# 테스트
#Get-Mailbox -OrganizationalUnit "OU=모바일파트,OU=운영담당,OU=전산팀,OU=경영전략부문,OU=지원,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr"  | Set-Mailbox -IssueWarningQuota 250mb -ProhibitSendQuota 300mb -ProhibitSendReceiveQuota 320mb -UseDatabaseQuotaDefaults $false -WhatIf
#Get-Mailbox -OrganizationalUnit "OU=모바일파트,OU=운영담당,OU=전산팀,OU=경영전략부문,OU=지원,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr" | Set-Mailbox -UseDatabaseQuotaDefaults $true
#Get-Mailbox -Identity "cowzero87"  | Set-Mailbox -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1020mb -UseDatabaseQuotaDefaults $false -WhatIf
#Get-Mailbox -Identity "cowzero87" | Set-Mailbox -UseDatabaseQuotaDefaults $true

# 사서함 용량 확인
Get-MailboxStatistics 20070131 |fl


# 사서함 크기 예외 설정 사용자 확인 
Get-Mailbox -Filter {UseDatabaseQuotaDefaults -eq 'False'} -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" | Select Name,Alias,DisplayName,DistinguachedName,UseDatabaseQuotaDefaults,ProhibitSendQuota,
ProhibitSendReceiveQuota,IssueWarningQuota

# 사서함 크기 예외 설정 사용자 확인(파일로 떨구기)
Get-Mailbox -Filter {UseDatabaseQuotaDefaults -eq 'False'} -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr"| Select Name,Alias,DisplayName,DistinguachedName,UseDatabaseQuotaDefaults,ProhibitSendQuota,
ProhibitSendReceiveQuota,IssueWarningQuota | Export-CSV C:\BEVERAGE_EXUSER.CSV –Encoding UTF8