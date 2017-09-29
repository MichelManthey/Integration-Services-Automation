$ModulePath = "C:\Users\DBretz\Ceteris\Projekte\Intern\Integration-Services-Automation\CIsa"
Import-Module $ModulePath -Force

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection "Data Source=DEVELSQL16;Initial Catalog=master;Integrated Security=SSPI;"
$IntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $SqlConnection


$FoNa = 'PSCisa_DBR_4'
$PoNa = 'SampleSSIS'
$IspacSourcePath = "C:\Users\DBretz\Ceteris\Projekte\Intern\Integration-Services-Automation\Demo\SampleSSIS\SampleSSIS\bin\Development\SampleSSIS.ispac"
$EnvName1 = 'Dev_4'
$EnvName2 = 'QA_4'
$EnvVarInitialCatalog = "str_DWHInitialCatalog"
$EnvVarServerName = "str_DWHServerName"

New-CIsaFolder -IntegrationServices $IntegrationServices -FolderName $FoNa
$Fo= Get-CIsaFolder -IntegrationServices $IntegrationServices -FolderName $FoNa

New-CIsaProject -Folder $Fo -IspacSourcePath $IspacSourcePath -ProjectName $PoNa
$Po = Get-CIsaProject -Folder $Fo -ProjectName $PoNa

New-CIsaEnvironment -Folder $fo -EnvironmentName $EnvName1
New-CIsaEnvironment -Folder $fo -EnvironmentName $EnvName2

$Env1 = Get-CIsaEnvironment -Folder $fo -EnvironmentName $EnvName1
$Env2 = Get-CIsaEnvironment -Folder $fo -EnvironmentName $EnvName2

New-CIsaEnvironmentVariable -Environment $Env1 -VariableName $EnvVarInitialCatalog -VariableType "String" -VariableDefaultValue "CisaSample" -Override 
New-CIsaEnvironmentVariable -Environment $Env1 -VariableName $EnvVarServerName -VariableType "String" -VariableDefaultValue "DEVELSQL16" -Override 
New-CIsaEnvironmentVariable -Environment $Env1 -VariableName "str_NameSuffix" -VariableType "String" -VariableDefaultValue "World" -Override 

New-CIsaEnvironmentVariable -Environment $Env2 -VariableName $EnvVarInitialCatalog -VariableType "String" -VariableDefaultValue "CisaSample" -Override 
New-CIsaEnvironmentVariable -Environment $Env2 -VariableName $EnvVarServerName -VariableType "String" -VariableDefaultValue "DEVELSQL16" -Override 
New-CIsaEnvironmentVariable -Environment $Env2 -VariableName "str_NameSuffix" -VariableType "String" -VariableDefaultValue "Berlin" -Override 

New-CIsaProjectReference -Project $Po -FolderName $FoNa -EnvironmentName $EnvName1
New-CIsaProjectReference -Project $Po -FolderName $FoNa -EnvironmentName $EnvName2
