<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
#>
function Get-CIsaProjectReference
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

        $Project = $Folder.Projects[$ProjectName] 
        $EnvironmentReference = $Project.References.Item($EnviromentName, $Folder.Name)   

        Return $EnvironmentReference
    }

    End{}


}

