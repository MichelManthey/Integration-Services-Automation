<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD
#>
function Get-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServicesObject,

    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName
    )

    Begin{}

    Process{

        switch ($IntegrationServicesObject.GetType().Name){
            "IntegrationServices"{
                Write-Verbose -Message "Select by Integration Service"
                $Catalog = Get-CSSISDBCatalog -IntegrationServices $IntegrationServicesObject
            }
            "Catalog"{
                Write-Verbose -Message "Object is Catalog"
                $Catalog = $IntegrationServicesObject
            }
            default{
                Write-Warning -Message "TBD SELECT By Config String"
            }
        }


        Return $Catalog.Folders[$FolderName]
    }

    End{}


}

