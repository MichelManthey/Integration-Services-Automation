<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD
#>
function Get-CIsaEnvironmentVariable
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Environment,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableName
    )
    Begin{}

    Process{
        Write-Verbose -Message "Select Environment Variable"
        if(!$Environment.Variables){
            Write-Verbose -Message "Environment Variable $($VariableName) does not exist"
            $VariableName = $null
        }else{
            $VariableName = $Environment.Variables[$VariableName]
        }
        return($VariableName)
        
    }

    End{}


}