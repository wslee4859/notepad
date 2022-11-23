.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto

(get-mailbox).count

#사서함 별 메일박스 카운트 수 

Get-Mailbox  -ResultSize Unlimited | Group-Object -Property:database | Select-Object name, count

Get-Mailbox  -ResultSize Unlimited | Group-Object -Property:servername | Select-Object name, count

#사서함별 용량 및 화이트 스페이스 
get-mailboxdatabase -status | ft name, databasesize, *availableNew*

Get-Mailbox wslee4859 | -fil| select *


#사서함 Database 위치 확인
get-mailbox mail* | ft identity, database
get-mailbox cowzero87 | ft identity, database

# 사서함 DB 이동 
get-mailbox -identity kunha.0523 | New-MoveRequest -TargetDatabase "MBXDB01"
New-MoveRequest wslee4859@lottechilsung.co.kr -TargetDatabase MBXDB03 -WhatIf 
New-MoveRequest kboss77@lottechilsung.co.kr -TargetDatabase MBXDB02 
get-mailbox -identity cowzero87 | New-MoveRequest -TargetDatabase MBXDB04
get-mailbox  | ft identity, database 

New-MoveRequest cowzero87@lottechilsung.co.kr -TargetDatabase "Mailbox Database 0729431427"


get-mailbox cgu73th | ft identity, database
get-mailboxdatabase mbxdb04 | select *


Get-MoveRequestStatistics wslee4859 

#사서함 이동 상태 확인 
Get-MoveRequest | Get-MoveRequestStatistics


#완료된거 리스트 삭제
Get-MoveRequest -movestatus completed | remove-moverequest


get-mailbox -Database mbxdb04 -OrganizationalUnit "ou=전산팀,OU=경영전략부문,OU=지원,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr" | fl name, display*

get-mailbox -Database mbxdb04 | fl name, display*
Get-Mailbox mail14

