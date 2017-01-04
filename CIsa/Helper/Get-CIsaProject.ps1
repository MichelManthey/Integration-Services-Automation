<#

.SYNOPSIS
Get ProjectInfo objects from a CatalogFolder.

.DESCRIPTION
Returns project as Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance objects from a given folder.
If the function is called without a project name, then all projects will be returned.
Returns one or more Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance ProjectInfo objects or null.

.EXAMPLE
Get-CIsaProject -Folder $Folder
Get-CIsaProject -Folder $Folder -ProjectName "TestProject"

#>
function Get-CIsaProject
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object.
		[Parameter(,Mandatory=$FALSE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Name of the project.
		[Parameter(Mandatory=$FALSE)]
		[string]$ProjectName
    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a CatalogFolder" -ErrorAction Stop
        }
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

