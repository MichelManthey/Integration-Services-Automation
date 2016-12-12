<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function New-CSSISDBCatalog
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

        # TBD
		[Parameter(Mandatory=$FALSE)]
		[string]$SSISDBName = 'SSISDB',

        # TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$SSISDBPassword,
		
        # TBD
        [Parameter(Mandatory=$FALSE)]
        [string]$PartialName = 'Microsoft.SqlServer.Management.IntegrationServices.Catalog'


    )
    Begin{}

    Process{
        Write-Verbose -Message "Creating SSIS Catalog"
        $Catalog = New-Object $PartialName ($IntegrationServices, $SSISDBName, $SSISDBPassword)
        $Catalog.Create()
		Write-Verbose -Message "Catalog was created"
		return($Catalog)
    }

    End{}


}