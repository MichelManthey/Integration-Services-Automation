<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD
#>
function Get-CIsaEnviroment
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$EnviromentName
    )
    Begin{}

    Process{
        Write-Verbose -Message "Select Enviroment"
        $Environment = $Folder.Environments[$EnviromentName]
        return($Environment)
        
    }

    End{}


}