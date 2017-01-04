<#

.SYNOPSIS
Creates a new CatalogFolder.

.DESCRIPTION
Creates a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object for a given IntegrationServicesObject.
The IntegrationServicesObject can be Catalog object or an integration services object.

.EXAMPLE
New-CIsaFolder -Catalog $Catalog -FolderName "Test"

#>
function New-CIsaFolder
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

    	# Name of the folder that will be created.
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName, 

        # Description of the folder that will be created.
		[Parameter(Mandatory=$false)]
		[string]$FolderDescription = ' '

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

