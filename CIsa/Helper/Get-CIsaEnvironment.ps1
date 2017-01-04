<#

.SYNOPSIS
Get EnvironmentInfo objects from a folder.

.DESCRIPTION
Returns one ore more Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentInfo objects or null from a given folder.
If the function is called without an environment name, then all environments will be returned.

.EXAMPLE
Get-CIsaEnvironment -Folder $Folder
Get-CIsaEnvironment -Folder $Folder -EnvironmentName "Dev"

#>
function Get-CIsaEnvironment
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Name of the Environment.
        [Parameter(Mandatory=$FALSE)]
        [string]$EnvironmentName
    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"

        If($Folder.GetType().Name -notlike "CatalogFolder"){
	        Write-Error -Message "Variable Folder is not a CatalogFolder" -ErrorAction Stop
        }
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