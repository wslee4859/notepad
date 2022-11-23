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

$day = 7;

for($i = 0; $i -lt 1; $i++){

$filenameday = (Get-Date).AddDays(-$day).ToString("yyyy_MM_dd")
$today = (Get-Date).ToString("yyyy/MM/dd")
$yesterday = (Get-Date).AddDays(-$day).ToString("yyyy/MM/dd")
$filename = "D:\DATALAKE\LCSEKW3EXCH01_$filenameday.csv"
$sever = $env:COMPUTERNAME
#Write-Host $sever


$filename1 = "\\lcsekw3exch01\DATALAKE\LCSEKW3EXCH01_$filenameday.csv"
$filename2 = "\\lcsekw3exch02\DATALAKE\LCSEKW3EXCH02_$filenameday.csv"
$filename3 = "\\lcsekw3exch03\DATALAKE\LCSEKW3EXCH03_$filenameday.csv"
$filename4 = "\\lcsekw3exch04\DATALAKE\LCSEKW3EXCH04_$filenameday.csv"

$day++

Get-MessageTrackingLog -server lcsekw3exch01 -start "$yesterday 00:00:00" -end "$yesterday 23:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > $filename1  -NoTypeInformation
Get-MessageTrackingLog -server lcsekw3exch02 -start "$yesterday 00:00:00" -end "$yesterday 23:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > $filename2  -NoTypeInformation
Get-MessageTrackingLog -server lcsekw3exch03 -start "$yesterday 00:00:00" -end "$yesterday 23:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > $filename3  -NoTypeInformation
Get-MessageTrackingLog -server lcsekw3exch04 -start "$yesterday 00:00:00" -end "$yesterday 23:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > $filename4  -NoTypeInformation


$MyFile1 = Get-Content $filename1
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($filename1, $MyFile1, $Utf8NoBomEncoding)

$MyFile2 = Get-Content $filename2
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($filename2, $MyFile2, $Utf8NoBomEncoding)


$MyFile3 = Get-Content $filename3
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($filename3, $MyFile3, $Utf8NoBomEncoding)


$MyFile4 = Get-Content $filename4
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($filename4, $MyFile4, $Utf8NoBomEncoding)


#$filename = "D:\DATALAKE\LCSEKW3EXCH02_20190930.csv"

##Get-MessageTrackingLog -server lcsekw3exch02 -start "09/30/2019 10:00:00" -end "09/30/2019 10:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp  | ConvertTo-Csv > D:\DATALAKE\LCSEKW3EXCH02_20190930.csv -NoTypeInformation
#Get-MessageTrackingLog -server lcsekw3exch02 -start "09/30/2019 10:00:00" -end "09/30/2019 10:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp  | convertto-CSV -notype | out-file -encoding Default -filepath $filename
#Get-MessageTrackingLog -server lcsekw3exch02 -start "$month/$day/$year 00:00:00" -end "$month/$Endday/$year 00:00:00" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > "D:\DATALAKE\LCSEKW3EXCH02_$year$month$day.csv"

#ConverTO CSV  사용했을 경우 아래처럼 NoBom 처리해야함.
#$MyFile = Get-Content $filename
#$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
#[System.IO.File]::WriteAllLines($filename, $MyFile, $Utf8NoBomEncoding)
}