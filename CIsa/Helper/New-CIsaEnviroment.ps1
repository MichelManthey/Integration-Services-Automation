<#

.SYNOPSIS
Adds an Environment to an existing folder.

.DESCRIPTION
Adds an EnvironmentInfo to an existing folder.
Returns an Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentInfo object

.EXAMPLE
New-CIsaEnvironment -Folder Folder -EnvironmentName "DEV"

#>
function New-CIsaEnvironment
{
    [cmdletBinding()]
    param
    (
        # Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object.
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Name of the environment.
        [Parameter(Mandatory=$TRUE)]
        [string]$EnvironmentName,
        
        # Description for Environment.
        [Parameter(Mandatory=$FALSE)]
        [string]$EnvironmentDescription = ''

    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($Folder -and $Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a catalogfolder" -ErrorAction Stop
        }
    }

    Process{
        Write-Verbose -Message "Creating environment"
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