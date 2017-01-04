<#

.SYNOPSIS
Removes a project from a folder.

.DESCRIPTION
Removes a ProjectInfo from a CatalogFolder.

.NOTES
TBD Removes Enironments first asd

.EXAMPLE
Remove-CIsaProject -Folder $Folder -ProjectName "test"

#>
function Remove-CIsaProject
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Name of the project, wich should be removed
        [Parameter(Mandatory=$TRUE)]
        [string]$ProjectName


    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"

        If($Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a catalogfolder" -ErrorAction Stop
        }
    }

    Process{
        $Project = $Folder.Projects[$ProjectName]
        if($Project){
            Write-Verbose -Message "Project $($Project.Name) will be removed"
            $Project.Drop()
        }else{
            Write-Verbose -Message "Project does not exist"
        }
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

