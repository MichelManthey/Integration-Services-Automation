<#

.SYNOPSIS
Creates a new project within folder.

.DESCRIPTION
Creates a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance ProjectInfo object for a given CatalogFolder.
A project will be overridden if the same name exists in the folder.

.EXAMPLE
New-CIsaProject -Folder $Folder -IspacSourcePath "C:\Projekte\test.ispac" -ProjectName "test"

#>
function New-CIsaProject
{
    [cmdletBinding()]
    param
    (
        # Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance folder object.
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Path to the Ispac file.
        [Parameter(Mandatory=$TRUE)]
        [string]$IspacSourcePath,

        # Name of the project, must be the same as the ispac name.
        [Parameter(Mandatory=$TRUE)]
        [string]$ProjectName
    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"

        If($Folder -and $Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a CatalogFolder" -ErrorAction Stop
        }
    }

    Process{
        [byte[]] $IspacSource = [System.IO.File]::ReadAllBytes($IspacSourcePath)
        if($Folder.Projects[$ProjectName]){
            Write-Verbose "Project $($ProjectName) exists and will be overridden"
        }

        $DeployOperation = $Folder.DeployProject($Projectname,$IspacSource)
        
        return($DeployOperation)
        
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) in $($Timespan.TotalSeconds) seconds"
    }


}

