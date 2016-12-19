<#

.SYNOPSIS
Adds an Environment to an existing folder.

.DESCRIPTION
Adds an Environment to an existing folder.

.EXAMPLE
New-CIsaEnvironment -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "FolderName") -EnvironmentName "DEV"

#>
function New-CIsaEnvironment
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$EnvironmentName,
        
        # TBD
        [Parameter(Mandatory=$FALSE)]
        [string]$EnvironmentDescription = ''

    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
    }

    Process{
        Write-Verbose "Creating environment"
        $Environment = New-Object 'Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo' ($Folder, $EnvironmentName, $EnvironmentDescription)
        $Environment.Create()
        
        return($Environment)
        
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}