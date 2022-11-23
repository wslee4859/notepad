.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


################################################
# 데이터레이크 tracking log 추출 스크립트 
# 작성일 2019-10-02
# 작성자 이완상
################################################


#$year = Get-Date -format "yyyy"
#$day = Get-Date -format "dd"
#$yesterday = (Get-Date).AddDays(-2).ToString("dd")
#$month = Get-Date -format "MM"


$filenameday = (Get-Date).AddDays(-1).ToString("yyyy_MM_dd")
$today = (Get-Date).ToString("yyyy/MM/dd")
$yesterday = (Get-Date).AddDays(-1).ToString("yyyy/MM/dd")
$filename = "D:\DATALAKE\LCSEKW3EXCH01_$filenameday.csv"
$sever = $env:COMPUTERNAME
#Write-Host $sever

Get-MessageTrackingLog -server $sever -start "$yesterday 00:00:00" -end "$yesterday 23:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > $filename  -NoTypeInformation

$MyFile = Get-Content $filename
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($filename, $MyFile, $Utf8NoBomEncoding)




#$filename = "D:\DATALAKE\LCSEKW3EXCH02_20190930.csv"

##Get-MessageTrackingLog -server lcsekw3exch02 -start "09/30/2019 10:00:00" -end "09/30/2019 10:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp  | ConvertTo-Csv > D:\DATALAKE\LCSEKW3EXCH02_20190930.csv -NoTypeInformation
#Get-MessageTrackingLog -server lcsekw3exch02 -start "09/30/2019 10:00:00" -end "09/30/2019 10:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp  | convertto-CSV -notype | out-file -encoding Default -filepath $filename
#Get-MessageTrackingLog -server lcsekw3exch02 -start "$month/$day/$year 00:00:00" -end "$month/$Endday/$year 00:00:00" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > "D:\DATALAKE\LCSEKW3EXCH02_$year$month$day.csv"

#ConverTO CSV  사용했을 경우 아래처럼 NoBom 처리해야함.
#$MyFile = Get-Content $filename
#$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
#[System.IO.File]::WriteAllLines($filename, $MyFile, $Utf8NoBomEncoding)