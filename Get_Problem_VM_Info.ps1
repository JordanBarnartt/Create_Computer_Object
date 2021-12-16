# Get information on a VM causing an issue.  Accepts either the machine name, or connected user's WatIAM as input

Import-Module VMware.VimAutomation.HorizonView
Get-Module -ListAvailable 'VMware.Hv.Helper' | Import-Module

$connected = $False
do {
	try
	{
		$server = Connect-HVServer -Server libconvdiprd01.private.uwaterloo.ca -ErrorAction Stop
		$connected = $True
	}
	catch
	{
		Write-Output "Horizon server connection failed.  Please try again."
		$connected = $False
	}
} while( $connected -ne $True)


while ($True) {

    $id = Read-Host "Enter name of VM or user's WatIAM"

    if ($id -match '(LIB)|(lib)')
    {
        $session = Get-HVLocalSession | Where-Object {$_.NamesData.MachineOrRDSServerName -like $id}
    }
    else
    {
        $session = Get-HVLocalSession | Where-Object {$_.NamesData.UserName -like $('*' + $id)}
    }

    Write-Host "`nTimeStamp:"
    Write-Host $(Get-Date -Format "yyyy-MM-dd HH:mm") "`n"

    Write-Host "User:"
    Write-Host $($session.NamesData.UserName -split "\\")[1] "`n"

    Write-Host "Agent Information:"
    Write-Host "Machine Name: " $session.NamesData.MachineOrRDSServerName
    Write-Host "Agent Version: " $session.NamesData.AgentVersion "`n"

    Write-Host "Client Information:"
    Write-Host "Client Type: " $session.NamesData.ClientType
    Write-Host "Client Name: " $session.NamesData.ClientName
    Write-Host "Client Version: " $session.NamesData.ClientVersion`n

}
