<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function Get-CSSISDBFolder
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

    Begin{
        $Config = ([xml](Get-Content -Path "$PSScriptRoot\CSSISDB.config.xml" -ErrorAction Stop)).Config
    }

    Process{

        switch ($IntegrationServicesObject.GetType().Name){
            "IntegrationServices"{
                Write-Verbose -Message "Select by Integration Service"
                $Catalog = Get-CSSISDBCatalog -IntegrationServices $IntegrationServices
            }
            "Catalog"{
                Write-Verbose -Message "Already select Catalog"
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

