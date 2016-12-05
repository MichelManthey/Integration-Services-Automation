Import-Module 'M:\Projekte\CSSISDB' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CSSISDB\CSSISDB.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection



#$SSISSDB_Catalog =  Get-CSSISDBCatalog -IntegrationServices $IntegrationServices -Verbose
#
#$Folder = Get-CSSISDBFolder  -IntegrationServicesObject $IntegrationServices -FolderName $Config.SSISDB.Folders.Folder[1].Name -Verbose
#$Folder = Get-CSSISDBFolder  -IntegrationServicesObject $SSISSDB_Catalog -FolderName $Config.SSISDB.Folders.Folder[1].Name -Verbose




###Demo
$SSISSDB_Catalog = Get-CSSISDBCatalog -IntegrationService $IntegrationServices
If(!$SSISSDB_Catalog){
    Write-Warning -Message "TBD"
}


$ConfigFolder =$Config.SSISDB.Folders.Folder[0]


$Folder = Get-CSSISDBFolder  -IntegrationServicesObject $SSISSDB_Catalog -FolderName $ConfigFolder.Name -Verbose
If(!$Folder){
   Write-Warning -Message "TBD"
   $Folder = New-CSSISDBFolder -Catalog $SSISSDB_Catalog -FolderName $ConfigFolder.Name -Verbose
}

Foreach ($ConfigProject in $ConfigFolder.Projects.Project){
   $Status = New-CSSISDBProject -Folder $Folder -IspacSourcePath $ConfigProject.Path -Projectname $ConfigProject.Name -Verbose
}



Remove-CSSISDBProject -Folder $Folder -Projectname "ImportWideWorldImporters"
Remove-CSSISDBProject -Folder $Folder -Projectname "LoadWideWorldImporters"
Remove-CSSISDBProject -Folder $Folder -Projectname $ConfigProject.Name




Remove-CSSISDBFolder -Folder $Folder