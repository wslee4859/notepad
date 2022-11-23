.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto

#owa 정책 확인
Get-OwaMailboxPolicy | fl > c:\temp\owamailboxpolicy.txt

#owa 정책 확인
Get-CaseMailbox cowzero87 > c:\temp\user1-successr.txt
Get-CaseMailbox kimseonguk21 > c:\temp\user2-error.txt

#owa 가상 디렉터리 설정
Get-OwaVirtualDirectory | fl > c:\temp\owavirtual.txt



