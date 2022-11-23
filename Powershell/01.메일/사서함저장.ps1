.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto

#사용자 계정 csv로 사서함 존재 여부 확인

NEW-MailboxExportRequest -Mailbox kwanghyunkim -FilePath \\localhost\D$\kwanghyunkim.pst


NEW-MailboxExportRequest -Mailbox piazza84 -FilePath \\localhost\D$\piazza84.pst

get-mailboxexportrequest
