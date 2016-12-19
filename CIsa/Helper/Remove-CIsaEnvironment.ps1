<#

.SYNOPSIS
Removes a Environment from a folder.

.DESCRIPTION
Removes a Environment from a folder.

.EXAMPLE
Remove-CIsaEnvironment -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "FolderName") -EnvironmentName "DEV"

#>
function Remove-CIsaEnvironment
{
    [cmdletBinding()]
    param
    (
    	# Folder object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Name of the Environment, wich will be removed.
        [Parameter(Mandatory=$TRUE)]
        [string]$EnvironmentName


    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
    }

    Process{
        $Environment = $Folder.Environments[$EnvironmentName]
        if($Project){
            Write-Verbose -Message "Environment $($Environment.Name) will be removed"
            $Environment.Drop()
        }else{
            Write-Verbose -Message "Environment $($Environment.Name) does not exist"
        }
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

