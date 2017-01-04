<#

.SYNOPSIS
Removes a folder from SSISDB. 

.DESCRIPTION
Removes a folder from SSISDB with all projects and environments.

.EXAMPLE
Remove-CIsaFolder -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServicesObject -FolderName "FolderName")
#>
function Remove-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance folder object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder
    )

    Begin{}

    Process{

        try{
            $Folder.Refresh()
        }Catch{
            Write-Error -Message "Problem refreshing Folder." -ErrorAction Stop
        }
        Foreach($EnvironmentName in $Folder.Environments.name){
            Remove-CIsaEnvironment -Folder $Folder -EnvironmentName $EnvironmentName
        }

        Foreach($ProjectName in $Folder.Projects.name){
            Remove-CIsaProject -Folder $Folder -Projectname $ProjectName
        } 

        Write-Verbose -Message "Folder $($Folder.Name) will be removed"
        $Folder.Drop()
    }

    End{}


}

