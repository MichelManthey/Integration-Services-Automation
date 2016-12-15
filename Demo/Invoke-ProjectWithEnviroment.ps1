Import-Module 'M:\Projekte\CIsa\CIsa' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CIsa\CIsa\CIsa.config.xml" -ErrorAction Stop)).Config  



#C:\Windows\assembly\GAC_MSIL\Microsoft.SqlServer.Management.IntegrationServices\13.0.0.0__89845dcd8080cc91\Microsoft.SqlServer.Management.IntegrationServices.dll
[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServicesObject = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection

$ConfigFolder = $Config.SSISDB.Folders.Folder | Where-Object "Name" -Like "DBR_Powershell" |select -First 1
$ConfigEnviroment = $Config.SSISDB.Enviroments.Enviroment | Where-Object "Name" -Like "DBR_Dev" | select -First 1
$ConfigProjects = $ConfigFolder.Projects.Project


Write-Host "Invoke Folder $($ConfigFolder.Name)"
$Folder = Invoke-CIsaFolder -FolderName $ConfigFolder.Name -Verbose -IntegrationServicesObject $IntegrationServicesObject




Foreach($ConfigProject in $ConfigProjects){
    Write-Host "$($ConfigProject.Name) in $($Folder.Name) will get an Enviroment $($ConfigEnviroment.Name)"
    Invoke-CIsaEnviromentProjectVariable -IntegrationServices $IntegrationServicesObject -FolderName $Folder.Name -EnviromentName $ConfigEnviroment.Name -ProjectName $ConfigProject.Name -Verbose
}