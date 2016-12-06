Import-Module 'M:\Projekte\CSSISDB\CSSISDB' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CSSISDB\CSSISDB\CSSISDB.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServicesObject = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection

$FolName = $Config.SSISDB.Folders.Folder[0].Name #Folder1 
Write-Host "Invoke Folder $($FolName)"
$Folder = Invoke-CSSISDBFolder -FolderName $FolName -Verbose -IntegrationServicesObject $IntegrationServicesObject


$EnvName = $Config.SSISDB.Enviroments.Enviroment[0].Name #DEV
$ProName = $Config.SSISDB.Folders.Folder[0].Projects.Project[0].Name #Project1
Write-Host "$($ProName) in $($FolName) will get an Enviroment $($EnvName)"
Invoke-CSSISDBEnviromentProjectVariable -IntegrationServices $IntegrationServicesObject -FolderName $FolName -EnviromentName $EnvName -ProjectName $ProName -Verbose


$ProName = $Config.SSISDB.Folders.Folder[0].Projects.Project[1].Name #Project2
Invoke-CSSISDBEnviromentProjectVariable -IntegrationServices $IntegrationServicesObject -FolderName $FolName -EnviromentName $EnvName -ProjectName $ProName -Verbose