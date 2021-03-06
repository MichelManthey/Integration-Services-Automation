﻿<#

.SYNOPSIS
Creates a variable for an environment.

.DESCRIPTION
Creates a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentVariable object for a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentInfo.
If the variable exists, it is not overridden. To override a variable use -Override.
					
.EXAMPLE
New-CIsaEnvironmentVariable -VariableName 'EnvInitialCatalog_Source' -VariableType 'String' -VariableDefaultValue 'WideWorldImporters' -Sensitivity "false" -Description "Source InitialCatalog"

#>
function New-CIsaEnvironmentVariable
{
    [cmdletBinding()]
    param
    (
		# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentInfo object.
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Environment,

        # Name of the variable.
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableName,

        # Type of the variable.
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableType,

        # Default value of the variable.
        [Parameter(Mandatory=$TRUE)]
        [string]$VariableDefaultValue,

        # Whether variable is saved encrypted or not.
        [Parameter(Mandatory=$FALSE)]
        [Switch]$VariableSensitivity,

        # Description of the variable.
        [Parameter(Mandatory=$FALSE)]
        [string]$VariableDescription = " ",

        # Whether the variable should be overridden if it exists. Standard is not to override.
        [Parameter(Mandatory=$false)]
        [Switch]$Override

    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
		If($Environment.GetType().Name -notlike "EnvironmentInfo"){
	        Write-Error -Message "Variable Environment is not a EnvironmentInfo" -ErrorAction Stop
        }
    }

    Process{
        if($Environment.Variables[$VariableName]){
            if($Override){
                Write-Verbose "$($VariableName) is existing and will be overridden"
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
        $Environment.alter()
        return($Environment)
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"    
    }
}
