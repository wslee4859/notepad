#if( (Get-PSSnapin | where {$_.Name -match "Microsoft.Exchange.Management.Powershell.E2010"}) -eq $null){
#	Add-PSSnapin Microsoft.Exchange.Management.Powershell.E2010
#}

$SERVERS = "LCSEKW3EXCH01","LCSEKW3EXCH02","LCSEKW3EXCH03","LCSEKW3EXCH04"


$ChkService = @()

ForEach ($SERVER in $SERVERS ) {

	$STATUS = Test-ServiceHealth -Server $SERVER
	Write-Host "------------------------------------------"
	Write-Host "������ : $SERVER"

	ForEach ($ST in $STATUS) {
		Write-Host "`t������ ���� $($ST.ServicesNotRunning)" -foregroundcolor "yellow"
	}
}