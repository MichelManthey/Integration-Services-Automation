Import-Module 'M:\Projekte\CSSISDB\CSSISDB' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CSSISDB\CSSISDB\Public\CSSISDB.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection

$SSISSDB_Catalog = Get-CSSISDBCatalog -IntegrationService $IntegrationServices
If(!$SSISSDB_Catalog){
    Write-Warning -Message "TBD"
}

Foreach($ConfigFolder in $Config.SSISDB.Folders.Folder){
    $Folder = Get-CSSISDBFolder  -IntegrationServicesObject $SSISSDB_Catalog -FolderName $ConfigFolder.Name -Verbose
    If(!$Folder){
        $Folder = New-CSSISDBFolder -Catalog $SSISSDB_Catalog -FolderName $ConfigFolder.Name -Verbose
    }

    Foreach ($ConfigProject in $ConfigFolder.Projects.Project){
        $Status = New-CSSISDBProject -Folder $Folder -IspacSourcePath $ConfigProject.Path -Projectname $ConfigProject.Name -Verbose
    }
}
