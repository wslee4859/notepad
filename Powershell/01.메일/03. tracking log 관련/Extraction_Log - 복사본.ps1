.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


################################################
# �����ͷ���ũ tracking log ���� ��ũ��Ʈ 
# �ۼ��� 2019-10-02
# ���������� 2019-11-07
# �ۼ��� �̿ϻ�
# �������� : 2019-11-07 �Ѵ뼭������ �α� ��� ���̰� ��
################################################


#$year = Get-Date -format "yyyy"
#$day = Get-Date -format "dd"
#$yesterday = (Get-Date).AddDays(-2).ToString("dd")
#$month = Get-Date -format "MM"


$filenameday = (Get-Date).AddDays(-1).ToString("yyyy_MM_dd")
$today = (Get-Date).ToString("yyyy/MM/dd")
$yesterday = (Get-Date).AddDays(-1).ToString("yyyy/MM/dd")
$filename = "D:\DATALAKE\LCSEKW3EXCH_$filenameday.csv"
$sever = $env:COMPUTERNAME
#Write-Host $sever



Get-ExchangeServer | Get-MessageTrackingLog -start "$yesterday 00:00:00" -end "$yesterday 23:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > $filename  -NoTypeInformation

$MyFile = Get-Content $filename
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($filename, $MyFile, $Utf8NoBomEncoding)




#$filename = "D:\DATALAKE\LCSEKW3EXCH02_20190930.csv"

##Get-MessageTrackingLog -server lcsekw3exch02 -start "09/30/2019 10:00:00" -end "09/30/2019 10:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp  | ConvertTo-Csv > D:\DATALAKE\LCSEKW3EXCH02_20190930.csv -NoTypeInformation
#Get-MessageTrackingLog -server lcsekw3exch02 -start "09/30/2019 10:00:00" -end "09/30/2019 10:59:59" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp  | convertto-CSV -notype | out-file -encoding Default -filepath $filename
#Get-MessageTrackingLog -server lcsekw3exch02 -start "$month/$day/$year 00:00:00" -end "$month/$Endday/$year 00:00:00" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes | Sort-Object -Property Timestamp | ConvertTo-Csv > "D:\DATALAKE\LCSEKW3EXCH02_$year$month$day.csv"

#ConverTO CSV  ������� ��� �Ʒ�ó�� NoBom ó���ؾ���.
#$MyFile = Get-Content $filename
#$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
#[System.IO.File]::WriteAllLines($filename, $MyFile, $Utf8NoBomEncoding)


Get-ExchangeServer | get-messagetrackinglog -start "2019/11/06 09:00:00" -end "2019/11/06 10:00:00" -ResultSize unlimited | Select-object Time*, EventID, ServerHostname, ConnectorId, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}},RecipientCount,  MEssageSubject, TotalBytes, original-server-ip | Sort-Object -Property Timestamp | ConvertTo-Csv > c:\file\wslee4859\test.csv  -NoTypeInformation | compress-archive



get-messagetrackinglog -start "2019/11/06 09:00:00" -end "2019/11/06 10:00:00" | fl *time*