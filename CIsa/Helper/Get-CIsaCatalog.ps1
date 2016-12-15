<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD
#>
function Get-CIsaCatalog
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

        # TBD
		[Parameter(Mandatory=$FALSE)]
		[string]$SSISDBName = 'SSISDB'

    )
    Begin{}

    Process{
        Return($IntegrationServices.Catalogs[$SSISDBName])
    }

    End{}


}

