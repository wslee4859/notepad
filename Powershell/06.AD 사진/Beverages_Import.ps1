$Username = "lottechilsung.co.kr\administrator"
$Password = "ekw"

$WebClient = New-Object System.Net.WebClient
$WebClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)

$files=get-childitem "\\10.120.6.96\p$\Storage\ADPhoto\BEV"
Get-Date | out-file "C:\ADPhoto\Schedule\PhotoLog.txt" -Append  #2016-02-23 이완상 로그 기록하기 추가
foreach($file in $files)
{
   $file_full_path=$file.FullName
   $employeeid=$file.BaseName
   $photo=[byte[]](get-content $file_full_path -encoding byte)
   Get-ADUser -Filter {employeeid -eq $employeeid} -SearchBase "OU=ekw,DC=lottechilsung,DC=co,DC=kr" | Set-ADUser -replace @{thumbnailPhoto=$photo}
   $employeeid | out-file "C:\ADPhoto\Schedule\PhotoLog.txt" -Append   #2016-02-23 이완상 로그 기록하기 추가
   remove-item -path $file_full_path -force
   write-output $employeeid
}