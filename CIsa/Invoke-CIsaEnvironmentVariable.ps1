<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD
#>
function Invoke-CIsaEnvironmentProjectVariable
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName,

        # TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$EnvironmentName,

        # TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$ProjectName


    )

    Begin{
        $Config = ([xml](Get-Content -Path "$PSScriptRoot\CIsa.config.xml" -ErrorAction Stop)).Config
    }

    Process{
        Write-Verbose -Message "Start Invoke-CIsaEnvironmentVariable"
        $Folder = Get-CIsaFolder  -IntegrationServicesObject $IntegrationServices -FolderName $FolderName
        if(!$Folder){
            Write-Warning -Message "$($Folder) does not exist" -ErrorAction Stop
        }
        $Environment = Get-CIsaEnvironment -Folder $Folder -EnvironmentName $EnvironmentName
        if(!$Environment){
            $Environment = New-CIsaEnvironment -Folder $Folder -EnvironmentName $EnvironmentName
        }

        Write-Verbose -Message "Select Environment config"
        $EnvironmentConfig = $Config.SSISDB.Environments.Environment | Where-Object "Name" -Like $EnvironmentName

        Foreach ($VariableConfig in $EnvironmentConfig.Variables.Variable){
            $Variable = Get-CIsaEnvironmentVariable -Environment $Environment -VariableName $VariableConfig.Name
            if(!$Variable){
                $Variable = New-CIsaEnvironmentVariable -Environment $Environment -VariableName $VariableConfig.Name -VariableType $VariableConfig.Type -VariableDefaultValue $VariableConfig.DefaultValue -VariableSensitivity $VariableConfig.Sensitivity -VariableDescription $VariableConfig.Description -Override
            }
        }
        $Environment.Alter()
        
        
        Write-Verbose -Message "Select Reference config" 
        $ReferencConfig = $Config.SSISDB.References.Reference | Where-Object {$_.'Folder' -Like $Folder.Name -and $_.'Project' -like $ProjectName -and $_.'Environment' -like $Environment.Name}
        $EnvironmentReference = Get-CIsaProjectReference -Folder $Folder -EnvironmentName $ReferencConfig.Environment -ProjectName $ReferencConfig.Project
       
        if(!$EnvironmentReference){
            New-CIsaProjectReference -Folder $Folder -EnvironmentName $ReferencConfig.Environment -ProjectName $ReferencConfig.Project
        }
       
        $Project = Get-CIsaProject -Folder $Folder -ProjectName $ReferencConfig.Project
        Foreach($VariableProjectConfig in $ReferencConfig.Variables.Variable){
            Set-CIsaVariable -Project $Project -ProjectParamName $VariableProjectConfig.ProjectParam -VariableName $VariableProjectConfig.VariableName
        }
        $Project.Alter()
        $EnvironmentReference = $Project.References.Item($ReferencConfig.Environment, $Folder.Name)
        $EnvironmentReference.Refresh()
    }

    End{}


}

