Enable-PSRemoting -Force
set-item WSMan:\localhost\Client\trustedhosts -Value "10.120.6.96, 10.120.6.84, 10.120.3.170, 10.120.2.175" -Force


$MyPassword = Read-Host "Password" -AsSecureString | ConvertFrom-SecureString

$MyPassword = $MyPassword | ConvertTo-SecureString
$ObjectTypeName = "System.Management.Automation.PSCredential"
$MyCredential = New-Object -TypeName $ObjectTypeName -ArgumentList "lcssvrgroup",$MyPassword


#Enter-PSSession -ComputerName "10.120.6.96" -Credential $MyCredential
#LCSEKW3DB01, CSHRDB01, LCSDBAMHO01, LCSBODB)


$LCSEKW3DB = Invoke-Command -ComputerName "10.120.6.96" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQLEWF)").ownernode.name}
$CSHRDB = Invoke-Command -ComputerName "10.120.6.84" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQLSERVER)").ownernode.name}
$LCSDBAMHO = Invoke-Command -ComputerName "10.120.3.170" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQLSERVER)").ownernode.name}
$LCSBODB = Invoke-Command -ComputerName "10.120.2.175" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQLSERVER)").ownernode.name}

Write-Host "LCSEKW3DB Node 소유자: "
Write-Host "$LCSEKW3DB" -foregroundcolor "yellow"
Write-Host "CSHRDB0 Node 소유자: "
Write-Host "$CSHRDB" -foregroundcolor "yellow"
Write-Host "LCSDBAMHO Node 소유자: "
Write-Host "$LCSDBAMHO" -foregroundcolor "yellow"
Write-Host "LCSBODB Node 소유자: "
Write-Host "$LCSBODB" -foregroundcolor "yellow"