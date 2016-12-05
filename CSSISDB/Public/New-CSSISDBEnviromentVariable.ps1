<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function New-CSSISDBEnviromentVariable
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Enviroment,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableName,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableType,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableDefaultValue,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [String]$VariableSensitivity,

        # TBD
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableDescription,

        # TBD
        [Parameter(Mandatory=$false)]
        [Switch]$Override

    )
    Begin{}

    Process{
        if($Enviroment.Variables[$VariableName]){
            if($Override){
                Write-Verbose "$($VariableName) is existing and will be overriden"
                $Enviroment.Variables.Remove($VariableName)
                $Enviroment.Alter()
                $Enviroment.Variables.Add($VariableName,[System.TypeCode]::$VariableType,$VariableDefaultValue,$VariableSensitivity,$VariableDescription)
            }else{
                Write-Verbose "$($VariableName) is existing"
            }

        }else{
            Write-Verbose -Message "Add Enviroment Variable $($VariableName) to Enviroment $($Enviroment.Name)"
            $Enviroment.Variables.Add($VariableName,[System.TypeCode]::$VariableType,$VariableDefaultValue,$VariableSensitivity,$VariableDescription)
        }
        return($Enviroment)
    }

    End{}
}