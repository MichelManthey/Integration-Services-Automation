<#

.SYNOPSIS
Creates a new project within folder.

.DESCRIPTION
Creates a project as an Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance object for a given folder.
A project will be overriden if the same name exist in the folder.

.EXAMPLE
New-CIsaProject -Folder (Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "Test") -IspacSourcePath "C:\Projekte\test.ispac" -ProjectName "test"

#>
function New-CIsaProject
{
    [cmdletBinding()]
    param
    (
        # Folder object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Path to the Ispac file
        [Parameter(Mandatory=$TRUE)]
        [string]$IspacSourcePath,

        # Name of the project, must be the same as the ispac name
        [Parameter(Mandatory=$TRUE)]
        [string]$ProjectName
    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
    }

    Process{
        [byte[]] $IspacSource = [System.IO.File]::ReadAllBytes($IspacSourcePath)
        if($Folder.Projects[$ProjectName]){
            Write-Verbose "Project $($ProjectName) exist and will be overriden"
        }

        $DeployOperation = $Folder.DeployProject($Projectname,$IspacSource)
        
        return($DeployOperation)
        
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

