.$env:exchangeinstallpath\bin\remoteexchange.ps1
connect-exchangeserver -Auto

#사용자 계정 csv로 사서함 존재 여부 확인

get-mailbox wslee4859 | fl
$i = 0;
import-csv C:\file\temp\pojang_op.csv | ForEach-Object {get-mailbox $_.login_id Write-Host "서버명 : $SERVER" }



$temp = import-csv C:\file\temp\test_list1.csv 
$i = 1;
ForEach ($login_id in $temp ) {

	#$STATUS = Test-ServiceHealth -Server $SERVER
	Write-Host "------------------------------------------"
	Write-Host "login_id : $login_id"
    Write-Host $i
    get-mailbox -Identity $login_id.login_id
    $i = $i+ 1	
}

