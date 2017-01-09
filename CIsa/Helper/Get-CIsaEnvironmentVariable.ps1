<#

.SYNOPSIS
Get a variable from an environment

.DESCRIPTION
Returns one or more Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentVariable object or null.
If VariableName is not given all variables will be returned.

.EXAMPLE
Get-CIsaEnvironmentVariable -Environment $Environment -VariableName 'EnvInitialCatalog_Source'
Get-CIsaEnvironmentVariable -Environment $Environment

#>
function Get-CIsaEnvironmentVariable
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentInfo object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Environment,

        # Name of the Variable which should be returned, if not given all variables will be returned 
        [Parameter(Mandatory=$FALSE)]
        [string]$VariableName
    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
		If($Environment.GetType().Name -notlike "EnvironmentInfo"){
	        Write-Error -Message "Variable Environment is not a EnvironmentInfo" -ErrorAction Stop
        }
    }

    Process{
        Write-Verbose -Message "Select Environment Variable"
        if(!$Environment.Variables){
            Write-Verbose -Message "Environment has no variables"
            $Variables = $null
        }else{
            if($VariableName){
                $Variables = $Environment.Variables[$VariableName]
            }else{
                $Variables = $Environment.Variables
            }

        }
        return($Variables)
        
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }
}
