<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
#>
function New-CIsaProjectReference
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$EnviromentName,

        # TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$ProjectName
    )

    Begin{}

    Process{
        Write-Verbose -Message "Set Project Reference"
        $Project = $Folder.Projects[$ProjectName] 
        $Project.References.Add($EnviromentName, $Folder.Name)
        $Project.Alter()
    }

    End{}


}

