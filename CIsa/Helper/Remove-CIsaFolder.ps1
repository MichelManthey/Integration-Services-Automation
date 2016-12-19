<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
TBD SfcInstance switch Folder, Catalog
#>
function Remove-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder
    )

    Begin{}

    Process{

        If($Folder){

            Foreach($EnvironmentName in $Folder.Environments.name){
                Remove-CIsaEnvironment -Folder $Folder -EnvironmentName $EnvironmentName
            }

            Foreach($ProjectName in $Folder.Projects.name){
                Remove-CIsaProject -Folder $Folder -Projectname $ProjectName
            } 

            Write-Verbose -Message "Folder $($Folder.Name) will be removed"
            $Folder.Drop()
        }else{
            Write-Warning -Message "Folder $($Folder.Name) does not exist"
        }
    }

    End{}


}

