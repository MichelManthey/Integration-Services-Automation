<#
.SYNOPSIS
Get a connection between a project to an environment.

.DESCRIPTION
Get a Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentReference object between a ProjectInfo from a folder to an EnvironmentInfo. 

.EXAMPLE
Get-CIsaProjectReference -Project $Project -EnvironmentName "DEV"
#>
function Get-CIsaProjectReference
{

    [CmdletBinding(DefaultParametersetName='ByProject')]  
    param
    (
    	# Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object.
		[Parameter(ParameterSetName='ByProjectName',Mandatory=$FALSE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

        # Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance ProjectInfo object.
		[Parameter(ParameterSetName='ByProject',Mandatory=$TRUE)]
        [Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Project,
        
        # Name of the project. 
        [Parameter(ParameterSetName='ByProjectName',Mandatory=$TRUE)]
        [string]$ProjectName,

    	# Name of the environment.
		[Parameter(Mandatory=$TRUE)]
		[string]$EnvironmentName,

        # Name of the folder.
        [Parameter(ParameterSetName='ByProject',Mandatory=$TRUE)]
        [String]$FolderName


    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"

        If($Folder -and $Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a CatalogFolder" -ErrorAction Stop
        }elseif($Folder -and $Folder.GetType().Name -like "CatalogFolder" ){
            $FolderName = $Folder.Name
            $Project = $Folder.Projects[$ProjectName] 
        } 
        
        If($Project -and $Project.GetType().Name -notlike "ProjectInfo" ){
            Write-Error -Message "Variable Project is not a ProjectInfo" -ErrorAction Stop
        }


    }

    Process{
        $EnvironmentReference = $Project.References.Item($EnvironmentName, $FolderName)
        Return $EnvironmentReference
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

