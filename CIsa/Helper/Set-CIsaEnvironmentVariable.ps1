<#

.SYNOPSIS
Links a project with an environment parameter.

.DESCRIPTION
Links a ProjectInfo with an EnvironmentVariable.

.NOTES
$Project.Alter() have to be used after all params are connected.

.EXAMPLE
Set-CIsaVariable -Project $Project -ProjectParamName Server -VariableName EnvServer
$Project.Alter()
#>
function Set-CIsaEnvironmentVariable
{
    [cmdletBinding()]
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance ProjectInfo object.
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Project,

    	# Parametername within project.
		[Parameter(Mandatory=$TRUE)]
		[string]$ProjectParamName,

        # Environmentname within environment.
		[Parameter(Mandatory=$TRUE)]
		[string]$VariableName
    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($Project.GetType().Name -notlike "ProjectInfo"){
            Write-Error -Message "Variable Project is not a project" -ErrorAction Stop
        }
    }

    Process{
        Write-Verbose "Set environment params"
        $Project.Parameters[$ProjectParamName].Set([Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,$VariableName)            
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

