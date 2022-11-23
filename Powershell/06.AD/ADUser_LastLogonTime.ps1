
################################################
# 데이터레이크 사용자 AD lastlogonTime 추출
# 작성일 2019-10-08
# 최종수정일 2019-11-08
# 작성자 이완상
# 수정내용 : 날짜수정 
#         : lastlogondata -> lastlogon 으로 데이터 추출 수정 
################################################


#$filenameday = (Get-Date).AddDays(-1).ToString("yyyy_MM_dd")
$filenameday = (Get-Date).AddDays(-1).ToString("yyyy_MM_dd")
$date = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")
#$filePath = "D:\DATALAKE_TEST\LCSEKW3EXCH_$filenameday.csv"
$filePath = "D:\DATALAKE\AD\ADUser_lastlogontime_$filenameday.csv"

# get-aduser ejkim1030 -property * | fl @{label='LastLogonDate';Expression={[DateTime]::FromFileTime($_.LastLogon).ToString('yyyy-MM-dd HH:mm:ss')}}

#Get-ADUser -filter * -SearchBase "ou=JJ,ou=Groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -Properties cn, displayname, Description, LastLogonDate, whenCreated, whenChanged | select @{label='reg_date';Expression={$date}}, Description, CN, Enabled, UserPrincipalName, Name, displayname, @{label='LastLogonDate_';Expression={get-date $_.LastLogonDate -format 'yyyy-MM-dd HH:mm:ss'}}, @{label='whenCreated_';Expression={get-date $_.whenCreated -format 'yyyy-MM-dd HH:mm:ss'}}, @{label='whenChanged_';Expression={get-date $_.whenChanged -format 'yyyy-MM-dd HH:mm:ss'}} | ConvertTo-Csv > $filePath  -NoTypeInformation
#lastlogon 으로 변경
Get-ADUser -filter * -SearchBase "ou=JJ,ou=Groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -Properties cn, displayname, Description, LastLogon, whenCreated, whenChanged | select @{label='reg_date';Expression={$date}}, Description, CN, Enabled, UserPrincipalName, Name, displayname, @{label='LastLogonDate';Expression={[DateTime]::FromFileTime($_.LastLogon).ToString('yyyy-MM-dd HH:mm:ss')}}, @{label='whenCreated_';Expression={get-date $_.whenCreated -format 'yyyy-MM-dd HH:mm:ss'}}, @{label='whenChanged_';Expression={get-date $_.whenChanged -format 'yyyy-MM-dd HH:mm:ss'}} | ConvertTo-Csv > $filePath  -NoTypeInformation



$MyFile = Get-Content $filePath
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($filePath, $MyFile, $Utf8NoBomEncoding)



