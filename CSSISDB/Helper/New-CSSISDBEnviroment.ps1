<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function New-CSSISDBEnviroment
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
        [Parameter(Mandatory=$FALSE)]
        [string]$EnvironmentDescription = '',

        # TBD
        [Parameter(Mandatory=$FALSE)]
        [string]$PartialName = 'Microsoft.SqlServer.Management.IntegrationServices.EnvironmentInfo'


    )
    Begin{}

    Process{
        Write-Verbose "Creating environment ..."
        $Environment = New-Object $PartialName ($Folder, $EnviromentName, $EnvironmentDescription)
        $Environment.Create()
        
        return($Environment)
        
    }

    End{}


}