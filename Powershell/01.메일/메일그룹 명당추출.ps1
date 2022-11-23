# 메일 그룹 명단 추출 

Get-DistributionGroup -resultSize Unlimited | export-csv -Path "C:\MailGroup.csv" -Encoding UTF8

# 추출 CSV -> 그룹 인원 정렬

import-csv C:\MailGroup.csv | foreach-object {Get-DistributionGroupMember -Identity $_.SamAccountName -resultSize Unlimited | Select Name, Alias, DisplayName, PrimarySmtpAddress, Department, $_.SamAccountName}  | Export-Csv -Path "C:\20210308Match.csv" -Encoding UTF8


Get-DistributionGroupMember -Identity "TIT_0040" | Format-List

Set-UserPhoto y.h.choi -PictureData ([System.IO.File]::ReadAllBytes("C:\20200127.jpg")) 
Set-UserPhoto yena0825 -PictureData ([System.IO.File]::ReadAllBytes("C:\20210005.jpg"))
Set-UserPhoto sehyun -PictureData ([System.IO.File]::ReadAllBytes("C:\20200188.jpg"))
