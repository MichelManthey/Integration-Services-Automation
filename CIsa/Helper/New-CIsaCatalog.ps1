<#

.SYNOPSIS
Creates a new SSISDB catalog.

.DESCRIPTION
Creates an SSISDB as a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance object for a given Integration Services object.
Returns a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance Catalog object.

.EXAMPLE
New-CIsaCatalog -IntegrationServices $IntegrationServices -SSISDBPassword "SuperStrong"

#>
function New-CIsaCatalog
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance IntegrationServices Object.
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

        # Password for the SSISDB catalog.
		[Parameter(Mandatory=$TRUE)]
		[string]$SSISDBPassword,

        # Name for the SSISDB catalog.
		[Parameter(Mandatory=$FALSE)]
		[string]$SSISDBName = 'SSISDB'

    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($IntegrationServices.GetType().Name -notlike "IntegrationServices" ){
            Write-Error -Message "Variable IntegrationServices is not an Integration Service" -ErrorAction Stop
        }
    }

    Process{
        $Catalog = New-Object 'Microsoft.SqlServer.Management.IntegrationServices.Catalog' ($IntegrationServices, $SSISDBName, $SSISDBPassword)
        $Catalog.Create()
		return($Catalog)
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}
