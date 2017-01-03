$ModulePath = "D:\Users\DBR\Projects\Powershell\Cisa\CIsa"
$Path = "$($ModulePath)\CIsa.config.simple.xml"

Import-Module $ModulePath -Verbose -Force

$Config = ([xml](Get-Content -Path $Path -ErrorAction Stop)).Config

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $SqlConnection


# Create Project via Config
Invoke-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "Microsoft_sql-server-samples" -PathToConfig $Path

# Invoke via helper functions
$FolderName = "Microsoft_sql-server-samples_way2"
$FolderDescription = "WideWorldImporters Sample Database for SQL Server and Azure SQL Database from https://github.com/Microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers#wideworldimporters-sample-database-for-sql-server-and-azure-sql-database"
$IspacSourcePath = "D:\Users\DBR\Projects\Powershell\Cisa\Demo\Daily_ETL.ispac"
$ProjectName = "Daily ETL"
$Catalog = Get-CIsaCatalog -IntegrationServices $IntegrationServices
If(!$Catalog){
    $Catalog = New-CIsaCatalog -IntegrationServices $IntegrationServices -SSISDBPassword "SuperPassword1+" -SSISDBName "SSISDB"
}
$Folder = Get-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName $FolderName
If(!$Folder){
    $Folder = New-CIsaFolder -FolderName $FolderName -FolderDescription $FolderDescription -IntegrationServicesObject $IntegrationServices
}
New-CIsaProject -Folder $Folder -IspacSourcePath $IspacSourcePath -ProjectName $ProjectName -ErrorAction Stop
