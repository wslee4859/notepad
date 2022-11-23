Add-PSSnapin Microsoft.Exchange.Management.Powershell.E2010 -ErrorAction SilentlyContinue

.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto

Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -messagesubject “발송0716”  -Start "05/13/2019 07:00:00 PM" -End "05/13/2019 07:32 PM"  |  ConvertTo-Csv > C:\file\trackinglog190513_0716.csv
Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -Sender "mail12@lottechilsung.co.kr" -Start "05/03/2019 07:00:00 AM" -End "05/03/2019 08:00:00 AM"  | Select-Object EventID, Source, Sender, Recipients, MEssageSubject, Time* | ConvertTo-Csv > C:\file\trackinglog190513_0953.csv
Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -Sender "mail13@lottechilsung.co.kr" -Start "05/03/2019 07:00:00 AM" -End "05/03/2019 08:00:00 AM"  | Select-Object EventID, Source, Sender, Recipients, MEssageSubject, Time* | ConvertTo-Csv > C:\file\trackinglog190513_0953.csv
Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -Sender "mail14@lottechilsung.co.kr" -Start "05/03/2019 07:00:00 AM" -End "05/03/2019 08:00:00 AM"  | Select-Object EventID, Source, Sender, Recipients, MEssageSubject, Time*  | ConvertTo-Csv > C:\file\trackinglog190513_0953.csv



Get-ExchangeServer | Get-MessageTrackingLog -MessageSubject "발송 1104"  -start "05/13/2019 11:00:00" -end "05/13/2019 11:05:00" -resultsize unlimited | ConvertTo-Csv > C:\file\trackinglog190513_1105.csv

Get-ExchangeServer | Get-MessageTrackingLog -Sender "mail11@lottechilsu" -Connectorld "조직 내 SMTP 송신 커넥"  -start "05/13/2019 09:50:00" -end "05/13/2019 09:58:00" -resultsize unlimited | ConvertTo-Csv > C:\file\trackinglog190513_0953.csv

Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -messagesubject “가상 계좌 sms 건” -Start "01/20/2017 13:00:00 PM" -End "01/23/2017 19:10:00 PM " | Select @{Name='Recipients';Expression={[string]::join(";", ($_.Recipients))}}, Sender, EventId, Timestamp, Source, MessageSubject,MessageID | Export-CSV "C:\file\Spam.csv" -Encoding UTF8



-Start "05/03/2015 01:00:00 AM" -End "05/03/2018 19:10:00 PM "
get-exchangeserver | Get-MessageTrackingLog -resultsize unlimited -messagesubject “매체예외신청”  -Recipients "gdkim@lotteliquor.com" | ft EventID, Source, Sender, Recipients, MEssageSubject, Time*


Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -messagesubject “POP”  -Recipients "hancutnews@lottechilsung.co.kr" | ft EventID, Source, Sender, Recipients, MEssageSubject, Time*


Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -messagesubject "다이소_대구성서점" -Recipients "20160200abc!@lottechilsung.co.kr" -Start "06/15/2018 01:00:00 AM" -End "06/15/2018 19:10:00 PM " | ft EventID, Source, Sender, Recipients, MEssageSubject, Time*

Get-Mailbox 20160200abc!



Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -messagesubject "다이소_대구성서점" -Recipients "20160200abc!@lottechilsung.co.kr" -Start "06/15/2018 01:00:00 AM" -End "06/15/2018 19:10:00 PM " | ft EventID, Source, Sender, Recipients, MEssageSubject, Time*

Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -Sender "june89@lottechilsung.co.kr" -Start "06/25/2018 15:00:00 PM" -End "06/25/2018 19:10:00 PM" | Select-Object EventID, Source, Sender, Recipients, MEssageSubject, Time* | Export-CSV "C:\file\temp\june89.csv" -Encoding UTF8


Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -Sender "lily.bang@homeplus.co.kr" -Start "07/19/2018 22:00:00 PM" -End "07/20/2018 14:00:00 PM" | Select-Object EventID, Source, Sender, Recipients, MEssageSubject, Time*





Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -Sender "lily.bang@homeplus.co.kr" -Start "07/19/2018 22:00:00 PM" -End "07/20/2018 14:00:00 PM" | Select-Object EventID, Source, Sender, Recipients, MEssageSubject, Time*

Get-ExchangeServer | Get-MessageTrackingLog -resultsize unlimited -Sender "taehwan0527@lotteliquor.com" | Select-Object EventID, Source, Sender, Recipients, MEssageSubject, Time* | Export-CSV "C:\file\temp\minahbae.csv" -Encoding UTF8


get-ExchangeServer | Get-MessageTrackingLog -ResultSize unlimited -EventId SEND -Start "06/15/20 01:00:00 AM" -End "06/15/2018 19:10:00 PM " | Where-Object {$_.Recipients -like "wslee4859@lotteliquor.com"} | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp  | Export-csv -Path C:\file\wslee4859\taehwan0527_recv.csv -encoding UTF8


Get-MessageTrackingLog -ResultSize unlimited -Start "07/04/2019 00:00:00" -End "07/05/2019 00:00:00" | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp  | Export-csv -Path C:\file\wslee4859\daily.csv -encoding UTF8


get-ExchangeServer | Get-MessageTrackingLog -ResultSize unlimited -Start "07/10/2019 01:00:00 AM" -End "07/10/2019 19:10:00 PM " | Where-Object {$_.Recipients -like "wslee4859@lottechilsung.co.kr"} | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp | Export-csv -Path C:\file\wslee4859\20190710_2.csv -encoding UTF8


get-ExchangeServer | Get-MessageTrackingLog -ResultSize unlimited -Start "07/10/2019 01:00:00 AM" -End "07/10/2019 19:10:00 PM " | Where-Object {$_.SENDER -like "kjc2093@gmail.com"} | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp 



Get-MessageTrackingLog -ResultSize unlimited -Start "07/04/2019 00:00:00" -End "07/05/2019 00:00:00" | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp  | Export-csv -Path C:\file\wslee4859\daily.csv -encoding UTF8


Get-MessageTrackingLog -Recipients "wslee4859@lottechilsung.co.kr" -ResultSize unlimited -Start "11/04/2019 00:00:00" -End "11/05/2019 00:00:00" | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp  


Get-MailboxDatabase | Get-MailboxDatabaseCopyStatus