<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function New-CSSISDBFolder
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Catalog,

    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName
    )

    Begin{
        $Config = ([xml](Get-Content -Path "$PSScriptRoot\CSSISDB.config.xml" -ErrorAction Stop)).Config
    }

    Process{
        $FolderConfig = $Config.SSISDB.Folders.Folder | Where-Object {$_.Name -eq $FolderName}
        $Folder= New-Object "$($Config.General.PartialName).CatalogFolder" ($Catalog, $FolderConfig.Name, $FolderConfig.Description)
        $Folder.Create()
        Write-Verbose -Message "Folder $($FolderConfig.Name) was created"

        Return $Folder
    }

    End{}


}

