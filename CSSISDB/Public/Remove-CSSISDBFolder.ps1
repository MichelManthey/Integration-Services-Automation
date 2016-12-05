<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
TBD SfcInstance switch Folder, Catalog
TBD Drop Project Params first...
#>
function Remove-CSSISDBFolder
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder
    )

    Begin{
        $Config = ([xml](Get-Content -Path "$PSScriptRoot\CSSISDB.config.xml" -ErrorAction Stop)).Config
    }

    Process{
        
        Write-Warning "Delete Projects first, contains Errors this ways"
        Foreach($Project in $Folder.Projects){
            Remove-CSSISDBProject -Folder $Folder -Projectname $Project.Name
        }
        Write-Verbose -Message "Remove Folder"
        $Folder.Drop()
    }

    End{}


}

