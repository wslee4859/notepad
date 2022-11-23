.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto


#사진 추출
#Export-RecipientDataProperty -Identity "karma076" -Picture | ForEach { $_.FileData | Add-Content C:\karma076.jpg -Encoding Byte}

#사진 업데이트
Set-UserPhoto -Identity cindypark -PictureData ([System.IO.File]::ReadAllBytes("C:\23060.jpg")) -whatif