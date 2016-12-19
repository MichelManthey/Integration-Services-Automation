<#

.SYNOPSIS
Get folder objects from a SSISDB.

.DESCRIPTION
Returns folder as  Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance objects from a given IntegrationServices Object. The IntegrationServicesObject can be an integration services or a catalog.
If the function is called without a folder name, then all folders will be returned.

.EXAMPLE
Get-CIsaFolder -IntegrationServicesObject $IntegrationServices
Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "TestFolder"

#>
function Get-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# Can be an integration services or a catalog object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServicesObject,

    	# Name of the folder
		[Parameter(Mandatory=$FALSE)]
		[string]$FolderName
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

        If($FolderName){
            Write-Verbose -Message "Returns one Folder"
            $Folders = $Catalog.Folders[$FolderName]
        }else{
            $Folders = $Catalog.Folders
        }

        Return $Folders
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

