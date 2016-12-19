<#

.SYNOPSIS
Get environment objects from a folder.

.DESCRIPTION
Returns environment as Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance objects from a given folder.
If the function is called without an environment name, then all environments will be returned.

.EXAMPLE
Get-CIsaEnvironment -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "FolderName")
Get-CIsaEnvironment -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "FolderName" -EnvironmentName "TestProject")

#>
function Get-CIsaEnvironment
{
    [cmdletBinding()]
    param
    (
    	# Folder object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Name of the Environment.
        [Parameter(Mandatory=$FALSE)]
        [string]$EnvironmentName
    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
    }

    Process{
        If($EnvironmentName){
            Write-Verbose -Message "Returns one environment"
            $Environments = $Folder.Environments[$EnvironmentName]
        }else{
            Write-Verbose -Message "Returns all environments"
            $Environments = $Folder.Environments
        }
        return($Environments)
 
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}