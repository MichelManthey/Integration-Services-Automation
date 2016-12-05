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

        If($Folder){
            Foreach($ProjectName in $Folder.Projects.name){
                Remove-CSSISDBProject -Folder $Folder -Projectname $ProjectName
            } 

            Write-Verbose -Message "Folder $($Folder.Name) will be removed"
            $Folder.Drop()
        }else{
            Write-Warning -Message "Folder $($Folder.Name) does not exist"
        }
    }

    End{}


}

