<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function Get-CSSISDBProject
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

