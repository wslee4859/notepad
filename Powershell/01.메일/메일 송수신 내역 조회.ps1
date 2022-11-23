.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


Get-MessageTrackingLog -server LCSEKW3EXCH01 -MessageSubject "발송_0951"  -start "05/13/2019 09:50:00" -end "05/13/2019 09:58:00" -ResultSize unlimited | ConvertTo-Csv > C:\file\trackinglog190513_ver2.csv
Get-MessageTrackingLog -server LCSEKW3EXCH01 -MessageSubject "발송_0951"  -start "05/13/2019 09:50:00" -end "05/13/2019 09:58:00" -ResultSize unlimited  | ConvertTo-Csv > C:\file\trackinglog190513_ver3.csv
Get-MessageTrackingLog -server LCSEKW3EXCH01 -MessageSubject "발송_0951"  -start "05/13/2019 09:50:00" -end "05/13/2019 09:58:00" -ResultSize unlimited  | ConvertTo-Csv > C:\file\trackinglog190513_ver4.csv



Get-MessageTrackingLog -server LCSEKW3EXCH02 -Sender "mail12@lottechilsung.co.kr"  -start "05/13/2019 09:50:00" -end "05/13/2019 09:58:00" -ResultSize unlimited | ConvertTo-Csv > C:\file\trackinglog190513_2.csv
Get-MessageTrackingLog -server LCSEKW3EXCH03 -Sender "mail13@lottechilsung.co.kr"  -start "05/13/2019 09:50:00" -end "05/13/2019 09:58:00" -ResultSize unlimited | ConvertTo-Csv > C:\file\trackinglog190513_3.csv
Get-MessageTrackingLog -server LCSEKW3EXCH04 -Sender "mail14@lottechilsung.co.kr"  -start "05/13/2019 07:00:00" -end "05/13/2019 09:19:00" -ResultSize unlimited | ConvertTo-Csv > C:\file\trackinglog190513_4.csv
# 메일 송수신 내역 조회 쿼리
# 메일서버별로 로그조회
# 

Get-MailboxDatabase 
Get-MessageTrackingLog -server LCSEKW3EXCH01 -Sender "wslee4859@lottechilsung.co.kr" | select  convertTo-csv > c:\file\sender.csv
Get-MessageTrackingLog -server LCSEKW3EXCH01 -Sender "mail11@lottechilsung.co.kr" -start "05/13/2019 07:00:00" -end "05/13/2019 09:19:00" -ResultSize unlimited | ConvertTo-Csv > C:\file\recipient.csv
Get-MessageTrackingLog -recipient "wslee4859@lottechilsung.co.kr" | ConvertTo-Csv > C:\file\recipient.csv

Get-MessageTrackingLog -server LCSEKW3EXCH01 -Sender "wslee4859@lottechilsung.co.kr" |  convertTo-csv > c:\file\sender.csv

Get-TransportService | select message*

get

get-exchangeserver | Get-MessageTrackingLog -start "08/26/2019 00:00:00" -end "08/28/2019 00:00:00" -a -ResultSize unlimited -EventId send | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp  | ConvertTo-Csv > C:\file\wslee4859\음용판촉.csv