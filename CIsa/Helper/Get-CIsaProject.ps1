<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
#>
function Get-CIsaProject
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$ProjectName
    )

    Begin{}

    Process{
        Write-Verbose -Message "Select Project Reference"
        $Project = $Folder.Projects[$ProjectName]
        Return($Project)
    }

    End{}


}

