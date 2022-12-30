
Enable-PSRemoting -Force
set-item WSMan:\localhost\Client\trustedhosts -Value "10.120.6.96, 10.120.6.84, 10.120.3.170, 10.120.2.175" -Force


#$MyPassword = Read-Host "Password" -AsSecureString | ConvertFrom-SecureString

#$MyPassword = $MyPassword | ConvertTo-SecureString
$MyPassword = '01000000d08c9ddf0115d1118c7a00c04fc297eb010000007e2d44961ce420489f6b287fcca03d500000000002000000000003660000c000000010000000bfc8cbf6535253f5e841c1dd650fea240000000004800000a000000010000000f3565bfcb855acd68b63f3ead8323ea620000000ce1ceba7e9414e393fc162508a2ed4a373a934e75aefd7e70cb9c0fdab2fc7501400000003dee23658bc4041bdd4e1ffae777e185dcbff8a'

$ObjectTypeName = "System.Management.Automation.PSCredential"
$MyCredential = New-Object -TypeName $ObjectTypeName -ArgumentList "lcssvrgroup",$MyPassword


#Enter-PSSession -ComputerName "10.120.6.96" -Credential $MyCredential
#LCSEKW3DB01, CSHRDB01, LCSDBAMHO01, LCSBODB)


$LCSEKW3DB = Invoke-Command -ComputerName "10.120.6.96" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQL_EWF)").ownernode.name}
$CSHRDB = Invoke-Command -ComputerName "10.120.6.84" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQLSERVER)").ownernode.name}
$LCSDBAMHO = Invoke-Command -ComputerName "10.120.3.170" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQLSERVER)").ownernode.name}
$LCSBODB = Invoke-Command -ComputerName "10.120.2.175" -Credential $MyCredential -Command {(Get-ClusterGroup -name "SQL Server (MSSQLSERVER)").ownernode.name}

$vContent = @"
"date","dbName","ownernode"
"$vToday","LCSEKW3DB","$LCSEKW3DB"
"$vToday","CSHRDB0","$CSHRDB"
"$vToday","LCSDBAMHO","$LCSDBAMHO"
"$vToday","LCSBODB","$LCSBODB"
"@

$vContent | ConvertFrom-Csv | Export-Csv -Path ".\DBFailOver.csv" -NoTypeInformation -Append


Write-Host "LCSEKW3DB Node 소유자: "
Write-Host "$LCSEKW3DB" -foregroundcolor "yellow"
Write-Host "CSHRDB0 Node 소유자: "
Write-Host "$CSHRDB" -foregroundcolor "yellow"
Write-Host "LCSDBAMHO Node 소유자: "
Write-Host "$LCSDBAMHO" -foregroundcolor "yellow"
Write-Host "LCSBODB Node 소유자: "
Write-Host "$LCSBODB" -foregroundcolor "yellow"