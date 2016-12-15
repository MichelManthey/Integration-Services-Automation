<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
#>
function New-CIsaProject
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$IspacSourcePath,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$Projectname


    )
    Begin{}

    Process{
        [byte[]] $IspacSource = [System.IO.File]::ReadAllBytes($IspacSourcePath)
        if($Folder.Projects[$Projectname]){
            Write-Verbose "Project $($Projectname) exist and will be overriden"
        }

        $DeployOperation = $Folder.DeployProject($Projectname,$IspacSource)
        
        return($DeployOperation)
        
    }

    End{}


}

