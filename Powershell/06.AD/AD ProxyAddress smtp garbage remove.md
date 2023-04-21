### 1.	넷츠에서 원격으로 AD계정에 proxyaddress 에 garbage 값이 들어간 계정 리스트를 추림

(하단에 기재한 내용을 파워쉘에서 실행시켜서 계정 리스트 추림)

```powershell
$RemoveTargetAddr = 'smtp:'
$SearchBase = 'OU=JJ,OU=Groups,OU=eKW,DC=lottechilsung,DC=co,DC=kr'

$UserList = Get-ADUser -Filter {proxyAddresses -like $RemoveTargetAddr} -Properties userPrincipalName, proxyAddresses, DistinguishedName -SearchBase $SearchBase
$UserList | Select-Object userprincipalname, @{name='proxyaddresses';expression={$_.proxyaddresses}} , DistinguishedName | Export-Csv -Path "D:\Confirm_smtp_ErrorUserList.csv" -Encoding UTF8 -NoTypeInformation

$cnt = 0;
$UserList | ForEach-Object {
    $cnt += 1
    Write-Output "[$($cnt)]UPN: $($_.UserPrincipalName) / DistinguishedName : $($_.DistinguishedName)"
    $RemoveFlag = $false

    $_.ProxyAddresses | ForEach-Object {
            Write-Output "Address: $_"

        if($_ -eq $RemoveTargetAddr){
            $RemoveFlag = $true
        }
    }
    
    if($Removeflag){
       #Remove Command
       #Set-ADUser -Identity $_.SamAccountName -remove @{ ProxyAddresses = $RemoveTargetAddr } -Debug -Verbose
    }
}
``` 

2.	해당 계정들의 AD계정에 proxyaddress 에 garbage 값 제거 명령어 실행 (전산팀 IM 담당자가 실행) -> 이 부분을 인프라 ad 담당이 하는 롤이 맞다고 판단

```powershell
$cnt = 0;
$UserList | ForEach-Object {
    $cnt += 1
    Write-Output "[$($cnt)]UPN: $($_.UserPrincipalName) / DistinguishedName : $($_.DistinguishedName)"
    $RemoveFlag = $false

    $_.ProxyAddresses | ForEach-Object {
            Write-Output "Address: $_"

        if($_ -eq $RemoveTargetAddr){
            $RemoveFlag = $true
        }
    }
    
    if($Removeflag){
       #Remove Command
       Set-ADUser -Identity $_.SamAccountName -remove @{ ProxyAddresses = $RemoveTargetAddr } -Debug -Verbose
    }
}
```
3.	IM AD 프로비저닝 테스트 후 성공 확인
4.	작업 종료
