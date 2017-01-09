<#

.SYNOPSIS
Removes an EnvironmentInfo from a CatalogFolder.

.DESCRIPTION
Removes an EnvironmentInfo from a CatalogFolder using a Folder with an EnvironmentName or an environment object

.EXAMPLE
Remove-CIsaEnvironment -Folder $Folder -EnvironmentName "DEV"

#>
function Remove-CIsaEnvironment
{
    [CmdletBinding(DefaultParametersetName='ByEnvironment')]  
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object
		[Parameter(ParameterSetName='ByEnvironmentName',Mandatory=$FALSE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        #Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentInfo object
        [Parameter(ParameterSetName='ByEnvironment',Mandatory=$TRUE)]
        [Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Environment,
        
        # Name of the Environment which will be removed.
        [Parameter(ParameterSetName='ByEnvironmentName',Mandatory=$TRUE)]
        [string]$EnvironmentName
    )
    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($Folder -and $Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a CatalogFolder" -ErrorAction Stop
        }elseif($Folder -and $Folder.GetType().Name -like "CatalogFolder" ){
            $Environment = $Folder.Environments[$EnvironmentName]
        }  

        If($Environment -and $Environment.GetType().Name -notlike "EnvironmentInfo" ){
            Write-Error -Message "Variable Environment is not an EnvironmentInfo" -ErrorAction Stop
        }  
    }

    Process{
        if($Environment){
            Write-Verbose -Message "Environment $($Environment.Name) will be removed"
            $Environment.Drop()
        }else{
            Write-Verbose -Message "Environment $($Environment.Name) does not exist"
        }
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

