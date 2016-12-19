<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
#>
function New-CIsaEnvironmentVariable
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Environment,

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
        [ValidateSet("true","false")] 
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
        
        if($VariableSensitivity -like "true"){
            [bool]$VariableSensitivity = $TRUE
        }else{
            [bool]$VariableSensitivity = $false
        }
        if($Environment.Variables[$VariableName]){
            if($Override){
                Write-Verbose "$($VariableName) is existing and will be overriden"
                $Environment.Variables.Remove($VariableName)
                $Environment.Alter()
                $Environment.Variables.Add($VariableName,[System.TypeCode]::$VariableType,$VariableDefaultValue,$VariableSensitivity,$VariableDescription)
            }else{
                Write-Verbose "$($VariableName) is existing"
            }

        }else{
            Write-Verbose -Message "Add Environment Variable $($VariableName) to Environment $($Environment.Name)"
            $Environment.Variables.Add($VariableName,[System.TypeCode]::$VariableType,$VariableDefaultValue,$VariableSensitivity,$VariableDescription)
        }
        return($Environment)
    }

    End{}
}