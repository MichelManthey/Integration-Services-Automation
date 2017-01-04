<#

.SYNOPSIS
Get a CatalogFolder object.

.DESCRIPTION
Returns a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object from an IntegrationServices object. 

.EXAMPLE
Get-CIsaCatalog -IntegrationServices $IntegrationServices

#>
function Get-CIsaCatalog
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance IntegrationServices object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

        # Name of the Integration Services-Catalog. Default value is SSISDB.
		[Parameter(Mandatory=$FALSE)]
		[string]$SSISDBName = 'SSISDB'

    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($IntegrationServices.GetType().Name -notlike "IntegrationServices" ){
            Write-Error -Message "Variable Folder is not a IntegrationServices" -ErrorAction Stop
        }
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

