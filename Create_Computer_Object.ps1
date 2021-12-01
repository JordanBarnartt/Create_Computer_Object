# Specific details redacted.

# Create_Computer_Object.ps1
# Creates a new device object in Active Directory based on user input.
#   Prompts for object name and choice of OU from predetermined list.
#   Also accepts command line aguments for object name and OU.
# Example: .\Create_Computer_Object.ps1 -object_name 'Lib-TestScript' -selected_OU 'Library'
# Author: Jordan Barnartt
# Date: 2021-12-01

Param(
    [string]$object_name = $false,
    [string]$selected_OU = $false
)

$creds = Get-Credential -Message 'Enter Active Directory credentials to create computer object.'

if ($object_name -like $false) {
    $object_name = Read-Host 'Enter the name of the new computer object'
}

$organizational_units = [ordered]@{
'OUKey' = 'OU Path';
}

while ($selected_OU -like $false)
{
    Write-Output "Enter the key of the OU the computer object should be placed in, from the following list.`n------"
    foreach($key in $organizational_units.keys)
    {
        Write-Output $key
    }
    Write-Output "------"
    $selected_OU = Read-Host 'Enter key'

    if ($organizational_units.keys -notcontains $selected_OU)
    {
    Write-Output 'Key not found.  Please try again.'
    $selected_OU = $false
    }
}

New-ADComputer -Credential $creds -DNSHostName $($object_name + '.HOST') -Name $object_name -Path $organizational_units[$selected_OU] -Server HOST
Write-Output "$object_name created in $($organizational_units[$selected_OU])."
