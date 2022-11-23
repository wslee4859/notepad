.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto





Get-MessageTrackingLog -ResultSize unlimited -Start "07/30/2019 00:00:00" -End "07/30/2019 00:00:00" | Select-object EventID, Source, Sender, @{l="Recipients";e={$_.Recipients -join " "}}, MEssageSubject, Time* | Sort-Object -Property Timestamp  | Export-csv -Path C:\file\wslee4859\daily.csv -encoding UTF8


Get-MessageTrackingLog -ResultSize unlimited -Start "07/30/2019 00:00:00" -End "07/31/2019 00:00:00" |  Export-csv -Path C:\file\wslee4859\lcsekw3exch01.csv -encoding UTF8

Get-MessageTrackingLog -server lcsekw3exch03 -ResultSize unlimited -Start "07/30/2019 00:00:00" -End "07/31/2019 00:00:00" |  Export-csv -Path C:\file\wslee4859\lcsekw3exch02.csv -encoding UTF8

