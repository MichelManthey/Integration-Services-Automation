<#

.SYNOPSIS
Creates a new folder.

.DESCRIPTION
Creates a folder as an Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance object for a given integration services object.
The IntegrationServicesObject can be catalog object or an integration services object.

.EXAMPLE
New-CIsaFolder -IntegrationServicesObject $IntegrationServicesObject -FolderName "Test"

#>
function New-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# Can be an integration services or a catalog object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServicesObject,

    	# Name of the folder that will be created
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName, 

        # Description of the folder that will be created
		[Parameter(Mandatory=$false)]
		[string]$FolderDescription = ''

    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
    }

    Process{
        switch ($IntegrationServicesObject.GetType().Name){
            "IntegrationServices"{
                Write-Verbose -Message "Select by integration services"
                $Catalog = Get-CIsaCatalog -IntegrationServices $IntegrationServicesObject
            }
            "Catalog"{
                Write-Verbose -Message "Select by catalog"
                $Catalog = $IntegrationServicesObject
            }
            default{
                Write-Warning -Message "TBD"
            }
        }


        $Folder= New-Object 'Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder' ($Catalog, $FolderName, $FolderDescription)
        $Folder.Create()
        Return $Folder
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

