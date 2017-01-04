<#

.SYNOPSIS
Get folder objects from SSISDB.

.DESCRIPTION
Returns one ore more  Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder objects from a given IntegrationServices Object. 
The IntegrationServicesObject can be an IntegrationServices or a Catalog object.
If the function is called without a folder name, then all CatalogFolder will be returned.

.EXAMPLE
Get-CIsaFolder -Catalog $Catalog
Get-CIsaFolder -IntegrationServices $IntegrationServices -FolderName "TestFolder"

#>
function Get-CIsaFolder
{
    [CmdletBinding(DefaultParametersetName='ByCatalog')] 
    param
    (
        # Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance Catalog object.
        [Parameter(ParameterSetName='ByCatalog',Mandatory=$TRUE)]
        [Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Catalog,

        # Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance IntegrationServices object.
		[Parameter(ParameterSetName='ByIntegrationServices',Mandatory=$TRUE)]
        [Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

    	# Name of the folder
		[Parameter(Mandatory=$FALSE)]
		[string]$FolderName
    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"


        If($Catalog -and $Catalog.GetType().Name -notlike "Catalog" ){
            Write-Error -Message "Variable Catalog is not a Catalog" -ErrorAction Stop
        }

        If($IntegrationServices -and $IntegrationServices.GetType().Name -notlike "IntegrationServices" ){
            Write-Error -Message "Variable IntegrationServices is not a IntegrationServices" -ErrorAction Stop
        }elseif($IntegrationServices -and $IntegrationServices.GetType().Name -like "IntegrationServices" ){
            Write-Verbose -Message "Select catalog by IntegrationServices"
            $Catalog = Get-CIsaCatalog -IntegrationServices $IntegrationServices
            If(!$Catalog){
               Write-Error -Message "Catalog does not exists" -ErrorAction Stop -RecommendedAction "Use Get-Help New-CIsaCatalog"
            }
        }
    }

    Process{
        If($FolderName){
            Write-Verbose -Message "Selecting one folder"
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

