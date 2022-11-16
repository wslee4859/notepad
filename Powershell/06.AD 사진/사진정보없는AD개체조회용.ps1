
# 음료 사진 정보 없는 AD 계정
Get-ADUser -Filter {Enabled -eq $true -and thumbnailPhoto -notlike "*"} -SearchBase "ou=롯데칠성음료(주),ou=JJ,ou=groups,ou=ekw,dc=lottechilsung,dc=co,dc=kr" -properties thumbnailPhoto, employeeID | ? {!$_.thumbnailPhoto} | select name | ConvertTo-csv > "C:\ADPhoto\20160726_1,csv"


#주류 사진 정보 없는 AD 계정
Get-ADUser -Filter {Enabled -eq $true -and thumbnailPhoto -notlike "*"} -SearchBase "OU=롯데주류,OU=members, OU=LotteBeverage,DC=lottechilsung,DC=co,DC=kr" -properties thumbnailPhoto | ? {!$_.thumbnailPhoto} | select name | ConvertTo-csv > "C:\ADPhoto\주류미등록ID.csv"

Get-ADUser -Filter {Enabled -eq $true -and thumbnailPhoto -notlike "*"} -SearchBase "OU=롯데주류,OU=members, OU=LotteBeverage,DC=lottechilsung,DC=co,DC=kr" -properties thumbnailPhoto | ? {!$_.thumbnailPhoto} | Get-ADUser -Properties employeeID | select employeeID | ConvertTo-csv > "C:\ADPhoto\주류미등록.csv"

# AD 모든 정보 조회
Get-ADUser wslee4859 -Properties * | select *
 
Get-ADUser -Filter {EmployeeID -eq 19026} | select *