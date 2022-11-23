# OU 단위 메일 사서함 용량 예외 설정 IssueWarningQuota : 보내기 금지, ProhibitSendQuota : 보내기 및 받기 금지, ProhibitSendReceiveQuota : 사서함에 대한 할당
Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr"  | Set-Mailbox -IssueWarningQuota 250mb -ProhibitSendQuota 300mb -ProhibitSendReceiveQuota 320mb -UseDatabaseQuotaDefaults $false -WhatIf
#롤백 전체 사용자 디폴드 크기로 가져가도록
#Get-Mailbox -OrganizationalUnit "ou=롯데주류,ou=Members,ou=LotteBeverage,dc=lottechilsung,dc=co,dc=kr" | Set-Mailbox -UseDatabeQuotaDefaults $true

#예외 사용자 설정
Set-Mailbox -Identity "kimsc" -IssueWarningQuota 450mb -ProhibitSendQuota 500mb -ProhibitSendReceiveQuota 512mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "wplee" -IssueWarningQuota 2450mb -ProhibitSendQuota 2500mb -ProhibitSendReceiveQuota 2520mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "kbs11" -IssueWarningQuota 1950mb -ProhibitSendQuota 2000mb -ProhibitSendReceiveQuota 2020mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "minjae.seo" -IssueWarningQuota 1950mb -ProhibitSendQuota 2000mb -ProhibitSendReceiveQuota 2020mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "shinwk" -IssueWarningQuota 1950mb -ProhibitSendQuota 2000mb -ProhibitSendReceiveQuota 2020mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "yoonbi" -IssueWarningQuota 1950mb -ProhibitSendQuota 2000mb -ProhibitSendReceiveQuota 2020mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "yorray" -IssueWarningQuota 1350mb -ProhibitSendQuota 1370mb -ProhibitSendReceiveQuota 1390mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "banght" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "dedalusism" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "dj.park" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "hoon" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "jaenampark" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "kimseonguk21" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "kyaeyoung" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false
Set-Mailbox -Identity "yhmpark" -IssueWarningQuota 950mb -ProhibitSendQuota 1000mb -ProhibitSendReceiveQuota 1200mb -UseDatabaseQuotaDefaults $false

