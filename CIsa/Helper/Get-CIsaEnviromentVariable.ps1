<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD
#>
function Get-CIsaEnviromentVariable
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Enviroment,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableName
    )
    Begin{}

    Process{
        Write-Verbose -Message "Select Enviroment Variable"
        if(!$Environment.Variables){
            Write-Verbose -Message "Enviroment Variable $($VariableName) does not exist"
            $VariableName = $null
        }else{
            $VariableName = $Environment.Variables[$VariableName]
        }
        return($VariableName)
        
    }

    End{}


}