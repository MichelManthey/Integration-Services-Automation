<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
#>
function Set-CIsaVariable
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Project,

    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$ProjectParamName,

        # TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$VariableName
    )

    Begin{}

    Process{
        Write-Verbose "Set Enviroment Params"
        $Project.Parameters[$ProjectParamName].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,$VariableName)            
    }

    End{}


}

