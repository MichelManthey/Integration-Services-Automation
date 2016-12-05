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
        [string]$EnvironmentDescription = ''
    )
    Begin{
        $Config = ([xml](Get-Content -Path "$PSScriptRoot\CSSISDB.config.xml" -ErrorAction Stop)).Config
    }

    Process{
        Write-Verbose "Creating environment ..."
        $Environment = New-Object "$($Config.General.PartialName).EnvironmentInfo" ($Folder, $EnviromentName, $EnvironmentDescription)
        $Environment.Create()
        
        return($Environment)
        
    }

    End{}


}