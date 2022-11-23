# 20210712 이건 365일 이전에 수정된 메일 박스 찾기

.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto
#exchange 웹서비스에 연결 실제로 배치를 돌리기 전에 해당 서비스에 연결이 되지 않으면 아래 웹서비스를 실행할 수 없다.

$lastYear = (Get-Date).AddDays((-365))

Get-Mailbox -OrganizationalUnit "OU=퇴직자조직,OU=JJ,OU=groups,OU=ekw,DC=lottechilsung,DC=co,DC=kr" -Filter " WhenChanged -gt '$lastYear' "|Export-Csv -Encoding UTF8 -NoTypeInformation "C:\퇴직자검증_2021_07_13.csv"

#Get-Mailbox를 Disable-Mailbox 로 변경해서 배치를 일정 주기로 돌리면 가능할 것 같다 혹은 remove-mailbox -Permanent $true

