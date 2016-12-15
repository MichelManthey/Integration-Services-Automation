<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD
#>
function Invoke-CIsaEnviromentProjectVariable
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
		[string]$EnviromentName,

        # TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$ProjectName


    )

    Begin{
        $Config = ([xml](Get-Content -Path "$PSScriptRoot\CIsa.config.xml" -ErrorAction Stop)).Config
    }

    Process{
        Write-Verbose -Message "Start Invoke-CIsaEnviromentVariable"
        $Folder = Get-CIsaFolder  -IntegrationServicesObject $IntegrationServices -FolderName $FolderName
        if(!$Folder){
            Write-Warning -Message "$($Folder) does not exist" -ErrorAction Stop
        }
        $Enviroment = Get-CIsaEnviroment -Folder $Folder -EnviromentName $EnviromentName
        if(!$Enviroment){
            $Enviroment = New-CIsaEnviroment -Folder $Folder -EnviromentName $EnviromentName
        }

        Write-Verbose -Message "Select Enviroment config"
        $EnviromentConfig = $Config.SSISDB.Enviroments.Enviroment | Where-Object "Name" -Like $EnviromentName

        Foreach ($VariableConfig in $EnviromentConfig.Variables.Variable){
            $Variable = Get-CIsaEnviromentVariable -Enviroment $Enviroment -VariableName $VariableConfig.Name
            if(!$Variable){
                $Variable = New-CIsaEnviromentVariable -Enviroment $Enviroment -VariableName $VariableConfig.Name -VariableType $VariableConfig.Type -VariableDefaultValue $VariableConfig.DefaultValue -VariableSensitivity $VariableConfig.Sensitivity -VariableDescription $VariableConfig.Description -Override
            }
        }
        $Enviroment.Alter()
        
        
        Write-Verbose -Message "Select Reference config" 
        $ReferencConfig = $Config.SSISDB.References.Reference | Where-Object {$_.'Folder' -Like $Folder.Name -and $_.'Project' -like $ProjectName -and $_.'Enviroment' -like $Enviroment.Name}
        $EnvironmentReference = Get-CIsaProjectReference -Folder $Folder -EnviromentName $ReferencConfig.Enviroment -ProjectName $ReferencConfig.Project
       
        if(!$EnvironmentReference){
            New-CIsaProjectReference -Folder $Folder -EnviromentName $ReferencConfig.Enviroment -ProjectName $ReferencConfig.Project
        }
       
        $Project = Get-CIsaProject -Folder $Folder -ProjectName $ReferencConfig.Project
        Foreach($VariableProjectConfig in $ReferencConfig.Variables.Variable){
            Set-CIsaVariable -Project $Project -ProjectParamName $VariableProjectConfig.ProjectParam -VariableName $VariableProjectConfig.VariableName
        }
        $Project.Alter()
        $EnvironmentReference = $Project.References.Item($ReferencConfig.Enviroment, $Folder.Name)
        $EnvironmentReference.Refresh()
    }

    End{}


}

