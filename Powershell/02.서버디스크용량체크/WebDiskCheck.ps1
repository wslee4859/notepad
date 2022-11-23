

#$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace

#Write-Host ("{0}GB total" -f [math]::truncate($disk.Size / 1GB))
#Write-Host ("{0}GB free" -f [math]::truncate($disk.FreeSpace / 1GB))



# disk 용량 값 선언
$Web1diskC = Get-WmiObject -ComputerName lcsekw3web01 win32_logicaldisk  -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace
$Web1diskD = Get-WmiObject -ComputerName lcsekw3web01 win32_logicaldisk  -Filter "DeviceID='D:'" | Select-Object Size, FreeSpace
$Web2diskC = Get-WmiObject -ComputerName lcsekw3web02 win32_logicaldisk  -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace
$Web2diskD = Get-WmiObject -ComputerName lcsekw3web02 win32_logicaldisk  -Filter "DeviceID='D:'" | Select-Object Size, FreeSpace
$Web3diskC = Get-WmiObject -ComputerName lcsekw3web03 win32_logicaldisk  -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace
$Web3diskD = Get-WmiObject -ComputerName lcsekw3web03 win32_logicaldisk  -Filter "DeviceID='D:'" | Select-Object Size, FreeSpace

#표시 
"1번 웹 C드라이브"
Write-Host ("{0}GB total" -f [math]::truncate($Web1diskC.Size / 1GB))
Write-Host ("{0}GB free" -f [math]::truncate($Web1diskC.FreeSpace / 1GB))
"1번 웹 D드라이브"
Write-Host ("{0}GB total" -f [math]::truncate($Web1diskD.Size / 1GB))
Write-Host ("{0}GB free" -f [math]::truncate($Web1diskD.FreeSpace / 1GB))
"2번 웹 C드라이브"
Write-Host ("{0}GB total" -f [math]::truncate($disk2.Size / 1GB))
Write-Host ("{0}GB free" -f [math]::truncate($disk2.FreeSpace / 1GB))
"2번 웹 D드라이브"
Write-Host ("{0}GB total" -f [math]::truncate($disk3.Size / 1GB))
Write-Host ("{0}GB free" -f [math]::truncate($disk3.FreeSpace / 1GB))
"3번 웹 C드라이브"
Write-Host ("{0}GB total" -f [math]::truncate($disk3.Size / 1GB))
Write-Host ("{0}GB free" -f [math]::truncate($disk3.FreeSpace / 1GB))
"3번 웹 D드라이브"
Write-Host ("{0}GB total" -f [math]::truncate($disk3.Size / 1GB))
Write-Host ("{0}GB free" -f [math]::truncate($disk3.FreeSpace / 1GB))




$Web1diskC_Size = [math]::truncate($Web1diskC.Size / 1GB) 
$Web1diskC_Free = [math]::truncate($Web1diskC.FreeSpace / 1GB)
$Web1diskC_dis = [int]$Web1diskC_Size - [int]$Web1diskC_Free
$Web1diskD_Size = [math]::truncate($Web1diskD.Size / 1GB) 
$Web1diskD_Free = [math]::truncate($Web1diskD.FreeSpace / 1GB)
$Web1diskD_dis = [int]$Web1diskD_Size - [int]$Web1diskD_Free

$Web2diskC_Size = [math]::truncate($Web2diskC.Size / 1GB) 
$Web2diskC_Free = [math]::truncate($Web2diskC.FreeSpace / 1GB)
$Web2diskC_dis = [int]$Web2diskC_Size - [int]$Web2diskC_Free
$Web2diskD_Size = [math]::truncate($Web2diskD.Size / 1GB) 
$Web2diskD_Free = [math]::truncate($Web2diskD.FreeSpace / 1GB)
$Web2diskD_dis = [int]$Web2diskD_Size - [int]$Web2diskD_Free

$Web3diskC_Size = [math]::truncate($Web3diskC.Size / 1GB) 
$Web3diskC_Free = [math]::truncate($Web3diskC.FreeSpace / 1GB)
$Web3diskC_dis = [int]$Web3diskC_Size - [int]$Web3diskC_Free
$Web3diskD_Size = [math]::truncate($Web3diskD.Size / 1GB)
$Web3diskD_Free = [math]::truncate($Web3diskD.FreeSpace / 1GB)
$Web3diskD_dis = [int]$Web3diskD_Size - [int]$Web3diskD_Free

#디스크 임계치 
$diskLimit = [int]20

#메일 내용
$Emailbody = "<b>LCSEKW3WEB01 : 10.120.6.51</b> <br>"
$Emailbody += "C:\드라이브 총용량 : <font color=blue>$Web1diskC_Size GB</font> <br>"
$Emailbody += "C:\드라이브 사용중 : <font color=blue>$Web1diskC_dis GB</font> <br>" 
if([int]$Web1diskC_Free -lt $diskLimit)    # 10보다 작을 경우 
{
    $Emailbody += "<b>C:\드라이브 사용가능 : </b><b><font color=red>$Web1diskC_Free GB</font></b><br>"               
}
else{
    $Emailbody += "<b>C:\드라이브 사용가능 : </b><b><font color=blue>$Web1diskC_Free GB</font></b><br>"
}
$Emailbody += "<br>"
$Emailbody += "D:\드라이브 총용량 : <font color=blue>$Web1diskD_Size GB</font> <br>"
$Emailbody += "D:\드라이브 사용중 : <font color=blue>$Web1diskD_dis GB</font> <br>"

if([int]$Web1diskD_Free -lt $diskLimit){
    $Emailbody += "<b>D:\드라이브 사용가능 : </b><b><font color=red>$Web1diskD_Free GB</font></b><br>"                 
}
else{
    $Emailbody += "<b>D:\드라이브 사용가능 : </b><b><font color=blue>$Web1diskD_Free GB</font></b><br>"
}
$Emailbody += "<br>"
$Emailbody += "<br>"
$Emailbody += "<b>LCSEKW3WEB02 : 10.120.6.52</b> <br>"
$Emailbody += "C:\드라이브 총용량 : <font color=blue>$Web2diskC_Size GB</font> <br>"
$Emailbody += "C:\드라이브 사용중 : <font color=blue>$Web2diskC_dis GB</font> <br>" 
if([int]$Web2diskC_Free -lt $diskLimit)    # 10보다 작을 경우 
{
    $Emailbody += "<b>C:\드라이브 사용가능 : </b><b><font color=red>$Web2diskC_Free GB</font></b> <br>"               
}
else{
    $Emailbody += "<b>C:\드라이브 사용가능 : </b><b><font color=blue>$Web2diskC_Free GB</font></b> <br>"
}
$Emailbody += "<br>"
$Emailbody += "D:\드라이브 총용량 : <font color=blue>$Web2diskD_Size GB</font> <br>"
$Emailbody += "D:\드라이브 사용중 : <font color=blue>$Web2diskD_dis GB</font> <br>"

if([int]$Web2diskD_Free -lt $diskLimit){
    $Emailbody += "<b>D:\드라이브 사용가능 : <font color=red>$Web2diskD_Free GB</font></b> <br>"                 
}
else{
    $Emailbody += "<b>D:\드라이브 사용가능 : <font color=blue>$Web2diskD_Free GB</font></b><br>"
}             
$Emailbody += "<br>"
$Emailbody += "<br>"
$Emailbody += "<b>LCSEKW3WEB03 : 10.120.6.53</b> <br>"
$Emailbody += "C:\드라이브 총용량 : <font color=blue>$Web3diskC_Size GB</font> <br>"
$Emailbody += "C:\드라이브 사용중 : <font color=blue>$Web3diskC_dis GB</font> <br>" 
if([int]$Web3diskC_Free -lt $diskLimit)    # 10보다 작을 경우 
{
    $Emailbody += "<b>C:\드라이브 사용가능 : <font color=red>$Web3diskC_Free GB</font></b> <br>"               
}
else{
    $Emailbody += "<b>C:\드라이브 사용가능 : <font color=blue>$Web3diskC_Free GB</font></b> <br>"
}
$Emailbody += "<br>"
$Emailbody += "D:\드라이브 총용량 : <font color=blue>$Web3diskD_Size GB</font> <br>"
$Emailbody += "D:\드라이브 사용중 : <font color=blue>$Web3diskD_dis GB</font> <br>"

if([int]$Web3diskD_Free -lt $diskLimit){
    $Emailbody += "<b>D:\드라이브 사용가능 : <font color=red>$Web3diskD_Free GB</font></b> <br>"                 
}
else{
    $Emailbody += "<b>D:\드라이브 사용가능 : <font color=blue>$Web3diskD_Free GB</font></b> <br>"
}   


#메일 보내는 부분
    $EmailSubject = [string]"그룹웨어 웹 서버 디스크 체크"
    $EmailFrom = "wslee4859@lottechilsung.co.kr" 
    $EmailTo = "wslee4859@lottechilsung.co.kr" 
    $SMTPServer = "owa.lottechilsung.co.kr" 
    $mailer = new-object Net.Mail.SMTPclient($smtpserver)
    $msg = new-object Net.Mail.MailMessage($EmailFrom,$EmailTo,$EmailSubject,$Emailbody)
    $msg.IsBodyHTML = $true
    $mailer.send($msg)