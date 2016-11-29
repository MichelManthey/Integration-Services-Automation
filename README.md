# CSSISDB
SSIS Catalog and Project Deployment with PowerShell

## Description 
TBD

# Installation
- Download Project
- Copy CSSISDB.example.config.xml and rename it to CSSISDB.config.xml
- Edit CSSISDB.config.xml to your needs

# Demo
```powershell
Import-Module DownloadPath
$Config = ([xml](Get-Content -Path "M:\Projekte\CSSISDB\CSSISDB.config.xml" -ErrorAction Stop)).Config
[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection

$SSISSDB_Catalog = Get-CSSISDBCatalog -IntegrationService $IntegrationServices
If(!$SSISSDB_Catalog){
  Write-Warning -Message "TBD"
}

$Folder = Get-CSSISDBFolder  -IntegrationServicesObject $SSISSDB_Catalog -FolderName $Config.SSISDB.Folders.Folder[0].Name -Verbose
If(!$Folder){
  $Folder = New-CSSISDBFolder -Catalog $SSISSDB_Catalog -FolderName $Config.SSISDB.Folders.Folder[0].Name -Verbose
}
```


