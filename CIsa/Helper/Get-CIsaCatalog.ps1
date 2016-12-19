<#

.SYNOPSIS
Get a SSISDB object.

.DESCRIPTION
Returns the SSISDB as an Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance object from a given integration services object. 

.EXAMPLE
Get-CIsaCatalog -IntegrationServices $IntegrationServices

#>
function Get-CIsaCatalog
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices object with a System.Data.SqlClient.SqlConnection object.
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

        # Name of the Integration Services-Catalog. Default value is SSISDB.
		[Parameter(Mandatory=$FALSE)]
		[string]$SSISDBName = 'SSISDB'

    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
    }

    Process{
        Return($IntegrationServices.Catalogs[$SSISDBName])
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }
}

