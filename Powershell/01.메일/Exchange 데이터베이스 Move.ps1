.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto

# Exchange 서버 재부팅 후 서버 DB  마운트 변경


#데이터베이스 마운트 확인
Get-MailboxDatabase 

get-mailbox mail11 | fl database, *server*
get-mailbox mail12 | fl database, *server*
get-mailbox mail13 | fl database, *server*
get-mailbox mail14 | fl database, *server*


#DAG 구성 복사 상태 확인
Get-MailboxDatabase mbxdb04 | Get-MailboxDatabaseCopyStatus
Get-MailboxDatabase | Get-MailboxDatabaseCopyStatus

Get-MailboxDatabaseCopyStatus

#데이터베이스 옴기기
Move-ActiveMailboxDatabase MBXDB01 -ActivateOnServer LCSEKW3EXCH01

Move-ActiveMailboxDatabase MBXDB03 -ActivateOnServer LCSEKW3EXCH03

Mount-Database 


Move-ActiveMailboxDatabase

#서버 큐 확인
Get-Queue -server LCSEKW3EXCH04 | ft -a
Get-ExchangeServer | Get-Queue
Get-ServerHealth

(Get-ADUser -SearchBase "OU=BI/인사파트,OU=운영담당,OU=전산팀,OU=기획부문,OU=지원,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr"  -Filter {Enabled -eq $true}).count


(Get-ADUser -SearchBase "OU=DL_10030,OU=DL,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr"  -Filter {Enabled -eq $true}).count


Get-ADUser -SearchBase "OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr" | fl
Get-ADUser -SearchBase "OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr" -Filter {sAMAccountName -eq 'wslee4859'}
         


Get-mailbox -Server lcsekw3exch04 


get-mailbox akrnfk0410 | fl

get-mailbox -database "Mailbox Database 0729431427" 

get-mailbox -database mbxdb04



Get-Mailbox | Group-Object -Property:Database | Select-Object Name,Count | Sort-Object Name | Format-Table -Auto

Get-Mailbox -ResultSize Unlimited | Group-Object -Property:Database | Select-Object Name,Count | Sort-Object Name | Format-Table -Auto
#2020-10-08 퇴직자 계정 비활성화 작업 

#2020-10-22 퇴직자 계정 비활성화 작업 
Import-Csv "C:\퇴직자DB_2020_10_22_퇴직자_구분_작업예정.csv" |ForEach-Object{ Disable-Mailbox -Identity $_.SamAccountName -Confirm:$false }

Import-Csv "C:\퇴직자DB_test_del.csv" |ForEach-Object{ connect-Mailbox -Identity $_.SamAccountName -database $_.ServerName -Confirm:$true } 

Import-Csv "C:\퇴직자DB_test_del.csv" |ForEach-Object{ connect-Mailbox -Identity $_.DisplayName -database $_.ServerName -User $_.SamAccountName -Alias $_.Alias -Confirm:$true }

Import-Csv "C:\(수정_로그인아이디 추가)음료 주류 2010_2019 퇴직자 명단_202010012.csv" |ForEach-Object{ Get-Mailbox -Identity $_.login_id} | select SamAccountName, alias, GUID, Identity, displayName, servername  |Export-Csv -Encoding UTF8 -NoTypeInformation "C:\퇴직자DB_2020_10_13.csv"

Get-MailboxDatabase mbxdb04 | Get-MailboxDatabaseCopyStatus

$dbs = Get-MailboxDatabase
$dbs | foreach {Get-MailboxStatistics -Database $_.DistinguishedName} | where {$_.DisconnectReason -eq "Disabled"} | Format-Table DisplayName,Database,DisconnectDate, alias

$dbs = Get-MailboxDatabase
$dbs | foreach {Get-MailboxStatistics -Database $_.DistinguishedName} | where {$_.DisconnectReason -eq "Disabled"} | Format-Table DisplayName,Database,DisconnectDate

Connect-MsolService
Get-msoluser-UserPrincipalNameUPN | fl LicenseReconciliationNeeded
#다시 살리려면, AD 활성화후 connect-box

Disable-Mailbox -Identity "jeonggeolhan" -Confirm:$true

connect-Mailbox -Identity "84bcdb7f-b6fb-43bf-87d3-3f8227ce1ac5" -user "jeonggeolhan" -database MBXDB03 -Confirm:$true

Enable-Mailbox -Arbitration -Identity "jeonggeolhan@lottechilsung.co.kr"
Set-Mailbox "Migration.f901cfae-733d-48e6-9c49-ff7fcafaecf7" -Arbitration -Management:$true

Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisplayName -eq “한정걸(차량정비담당(신협) 정비업무지원(신협))” } | Format-List -Property *

Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisplayName -eq “한정걸(차량정비담당(신협) 정비업무지원(신협))” } | fl * 

# 1. 이름이 정확하지 않을 때

Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisplayName -like “*하도열*” } | Format-List -Property *

# 1-1. 이름을 정확히 알 때

Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisplayName -eq “김종근(음료영업본부 영업전략부문)” } | Format-List -Property *

# 2. 이미 연결된 깡통 사서함이 있어서 연결을 해제할때 identity 는 로그인 아이디와 동일
Disable-Mailbox -Identity "jeonggeolhan" -Confirm:$true 
# 3. 이후에 기존 메일 박스와 연결 identity는 원래 메일 박스 guid, user는 사서함을 붙여줄 계정의 로그인 아이디
connect-Mailbox -Identity "84bcdb7f-b6fb-43bf-87d3-3f8227ce1ac5" -user "jeonggeolhan" -database MBXDB03 -Confirm:$true

Get-Mailboxstatistics -Database "MBXDB03" | foreach{Update-StoreMailboxState -Database _$.Database -confirm:$false}

get-MailboxDatabase "MBXDB03" | clean-mailboxdatabase

Get-Mailbox -Identity "jeonggeolhan"


