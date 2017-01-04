<#

.SYNOPSIS
Creates a connection between a project to an environment.

.DESCRIPTION
Creates Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance EnvironmentReference  between a ProjectInfo from a CatalogFolder to an EnvironmentInfo. 

.EXAMPLE
New-CIsaProjectReference -Project $Project -EnvironmentName "DEV"
#>
function New-CIsaProjectReference
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

        # Name of the folder.
        [Parameter(ParameterSetName='ByProject',Mandatory=$TRUE)]
        [string]$FolderName,

    	# Name of the environment.
		[Parameter(Mandatory=$TRUE)]
		[string]$EnvironmentName
    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"
        If($Folder -and $Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a catalogfolder" -ErrorAction Stop
        }elseif($Folder -and $Folder.GetType().Name -like "CatalogFolder" ){
            $FolderName = $Folder.Name
            $Project = $Folder.Projects[$ProjectName] 
        } 
        
        If($Project -and $Project.GetType().Name -notlike "ProjectInfo" ){
            Write-Error -Message "Variable Project is not a ProjectInfo" -ErrorAction Stop
        }
    }

    Process{
        Write-Verbose -Message "Set project reference"
        $Project.References.Add($EnvironmentName, $FolderName)
        $Project.Alter()
    }

    End{
        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

