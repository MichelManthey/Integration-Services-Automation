<#

.SYNOPSIS
Get project objects from a folder.

.DESCRIPTION
Returns project as Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance objects from a given folder.
If the function is called without a project name, then all projects will be returned.

.EXAMPLE
Get-CIsaProject -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "FolderName")
Get-CIsaProject -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "FolderName" -ProjectName "TestProject")

#>
function Get-CIsaProject
{
    [cmdletBinding()]
    param
    (
    	# Folder object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Name of the project
		[Parameter(Mandatory=$FALSE)]
		[string]$ProjectName
    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
    }

    Process{
        If($ProjectName){
            Write-Verbose -Message "Returns one project"
            $Projects = $Folder.Projects[$ProjectName]
        }else{
            Write-Verbose -Message "Returns all projects"
            $Projects = $Folder.Projects
        }

        Return($Projects)
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

