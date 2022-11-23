.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


#BI 인사파트 계정 추출
Get-aduser -SearchBase "OU=BI/인사파트,OU=운영담당,OU=전산팀,OU=기획부문,OU=지원,OU=롯데칠성음료(주),OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr" -filter {enabled -eq $true} | select-object samAccountname | export-csv c:\file\BIList.csv

#아사히 계정 추출
Get-Mailbox -Filter "EmailAddresses -like '*@lotteasahi.co.kr'" -RecipientTypeDetails UserMailbox | ft alias, Emailaddresses, PrimarysmtpAddress 

#CSV 파일로 추출
Get-Mailbox -Filter "EmailAddresses -like '*@lotteasahi.co.kr'" -RecipientTypeDetails UserMailbox -ResultSize Unlimited | Select-Object alias, PrimarysmtpAddress  | Export-Csv C:\file\BulkRemoveList1.csv 


#Get-mailbox ngood21 | ft alias, Emailaddresses, PrimarysmtpAddress -wrap

#추출한 파일로 작업 
Import-Csv "C:\file\BulkRemoveList.csv" | ForEach{Set-Mailbox -Identity $_.Alias -EmailAddresses @{Remove="smtp:"+$_.Alias+"@lotteasahi.co.kr"}}




get-mailbox