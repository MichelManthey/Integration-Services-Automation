$ModulePath = "D:\Users\DBR\Projects\Powershell\Cisa\CIsa"
$Path = "$($ModulePath)\CIsa.example.config.xml"

Import-Module $ModulePath -Force
$Config = ([xml](Get-Content -Path $Path -ErrorAction Stop)).Config

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $SqlConnection


# Create Project via Config
$Folder = Invoke-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "Microsoft_sql-server-samples" -PathToConfig $Path

#Create Environment by ProjectName
Invoke-CIsaProjectReference -Folder $Folder -PathToConfig $Path -ProjectName "Daily ETL"

#Or use by Project
$Project = Get-CIsaProject -Folder $Folder -ProjectName "Daily ETL"
Invoke-CIsaProjectReference -Project $Project -PathToConfig $Path