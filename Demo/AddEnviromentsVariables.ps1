Import-Module 'M:\Projekte\CSSISDB\CSSISDB' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CSSISDB\CSSISDB\Public\CSSISDB.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection

$ConfigFolder = $Config.SSISDB.Folders.Folder[0]
#Foreach($ConfigFolder in $Config.SSISDB.Folders.Folder){
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
#}