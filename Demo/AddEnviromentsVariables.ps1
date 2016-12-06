Import-Module 'M:\Projekte\CSSISDB\CSSISDB' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CSSISDB\CSSISDB\CSSISDB.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection

$ConfigFolder = $Config.SSISDB.Folders.Folder[0]
Foreach($ConfigFolder in $Config.SSISDB.Folders.Folder){
    $Folder = Get-CSSISDBFolder  -IntegrationServicesObject $IntegrationServices -FolderName $ConfigFolder.Name -Verbose
    If(!$Folder){
        Write-Warning "$($ConfigFolder.Name) does not exist"
    }

    
    Foreach ($EnviromentConfig in $Config.SSISDB.Enviroments.Enviroment){
        $Enviroment = Get-CSSISDBEnviroment -Folder $Folder -EnviromentName $EnviromentConfig.Name
        
        if(!$Enviroment){
            $Enviroment = New-CSSISDBEnviroment -Folder $Folder -EnviromentName $EnviromentConfig.Name
        }
        
        Foreach ($VariableConfig in $EnviromentConfig.Variables.Variable){
            $Variable = Get-CSSISDBEnviromentVariable -Enviroment $Enviroment -VariableName $VariableConfig.Name
            if(!$Variable){
                $Variable = New-CSSISDBEnviromentVariable -Enviroment $Enviroment -VariableName $VariableConfig.Name -VariableType $VariableConfig.Type -VariableDefaultValue $VariableConfig.DefaultValue -VariableSensitivity $VariableConfig.Sensitivity -VariableDescription $VariableConfig.Description -Verbose -Override
            }
        }
        $Enviroment.Alter()      
    }

     
    Foreach ($ReferencConfig in $Config.SSISDB.References.Reference | Where-Object 'Folder' -Like $Folder.Name){
       $Folder = Get-CSSISDBFolder -FolderName $ReferencConfig.Folder -IntegrationServicesObject $IntegrationServices
       $EnvironmentReference = Get-CSSISDBProjectReference -Folder $Folder -EnviromentName $ReferencConfig.Enviroment -ProjectName $ReferencConfig.Project
       
       if(!$EnvironmentReference){
           New-CSSISDBProjectReference -Folder $Folder -EnviromentName $ReferencConfig.Enviroment -ProjectName $ReferencConfig.Project
       }
       
       $Project = Get-CSSISDBProject -Folder $Folder -ProjectName $ReferencConfig.Project
       Foreach($VariableProjectConfig in $ReferencConfig.Variables.Variable){
          Set-CSSISDBVariable -Project $Project -ProjectParamName $VariableProjectConfig.ProjectParam -VariableName $VariableProjectConfig.VariableName -Verbose
       }
       $Project.Alter()
       $EnvironmentReference = $Project.References.Item($ReferencConfig.Enviroment, $Folder.Name)
       $EnvironmentReference.Refresh()
     }
}