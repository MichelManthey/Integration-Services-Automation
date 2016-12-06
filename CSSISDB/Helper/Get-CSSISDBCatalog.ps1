<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function Get-CSSISDBCatalog
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

