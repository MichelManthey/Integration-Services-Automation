<#

.SYNOPSIS
Removes a folder from SSISDB. 

.DESCRIPTION
Removes a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object from SSISDB with all projects and environments.

.EXAMPLE
Remove-CIsaFolder -Folder $Folder
#>
function Remove-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object.
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder
    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a catalogfolder" -ErrorAction Stop
        }

        try{
            $Folder.Refresh()
        }Catch{
            Write-Error -Message "Problem refreshing Folder." -ErrorAction Stop -RecommendedAction "Maybe Folder is not synchronous with server side. Try refresh integration services"
        }
    }

    Process{
        Foreach($EnvironmentName in $Folder.Environments.name){
            Remove-CIsaEnvironment -Folder $Folder -EnvironmentName $EnvironmentName
        }

        Foreach($ProjectName in $Folder.Projects.name){
            Remove-CIsaProject -Folder $Folder -Projectname $ProjectName
        } 

        Write-Verbose -Message "Folder $($Folder.Name) will be removed"
        $Folder.Drop()
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

