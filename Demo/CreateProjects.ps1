Import-Module 'M:\Projekte\CIsa\CIsa' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CIsa\CIsa\CIsa.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection

$SSISSDB_Catalog = Get-CIsaCatalog -IntegrationService $IntegrationServices
If(!$SSISSDB_Catalog){
    Write-Warning -Message "TBD"
}

Foreach($ConfigFolder in $Config.SSISDB.Folders.Folder){
   $Folder = Get-CIsaFolder  -IntegrationServicesObject $SSISSDB_Catalog -FolderName $ConfigFolder.Name -Verbose
   If(!$Folder){
       $Folder = New-CIsaFolder -Catalog $SSISSDB_Catalog -FolderName $ConfigFolder.Name -FolderDescription $ConfigFolder.Description -Partialname "$($Config.General.PartialName).CatalogFolder" -Verbose
   }
   
   Foreach ($ConfigProject in $ConfigFolder.Projects.Project){
       $Status = New-CIsaProject -Folder $Folder -IspacSourcePath $ConfigProject.Path -Projectname $ConfigProject.Name -Verbose
   }
}
