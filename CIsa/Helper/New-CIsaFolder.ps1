<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
#>
function New-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Catalog,

    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName, 

        # TBD
		[Parameter(Mandatory=$false)]
		[string]$FolderDescription = '', 
        
        # TBD
		[Parameter(Mandatory=$false)]
		[string]$Partialname = 'Microsoft.SqlServer.Management.IntegrationServices.CatalogFolder'

    )

    Begin{}

    Process{
        $Folder= New-Object $Partialname ($Catalog, $FolderName, $FolderDescription)
        $Folder.Create()
        Write-Verbose -Message "Folder $($FolderName) was created"

        Return $Folder
    }

    End{}


}

