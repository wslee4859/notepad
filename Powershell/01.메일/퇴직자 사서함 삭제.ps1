

$Mailboxes = Get-Content "c:\삭제명단.csv"
ForEach ($Mailbox in $Mailboxes)
{Disable-Mailbox -Identity $Mailbox -Confirm:$false}