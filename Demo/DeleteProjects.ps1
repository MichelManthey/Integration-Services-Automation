Import-Module 'M:\Projekte\CSSISDB\CSSISDB' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CSSISDB\CSSISDB\CSSISDB.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection


Foreach($ConfigFolder in $Config.SSISDB.Folders.Folder){
    $Folder = Get-CSSISDBFolder  -IntegrationServicesObject $IntegrationServices -FolderName $ConfigFolder.Name -Verbose
    Remove-CSSISDBFolder -Folder $Folder -Verbose
}