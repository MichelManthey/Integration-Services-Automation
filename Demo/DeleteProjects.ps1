Import-Module 'M:\Projekte\CIsa\CIsa' -Verbose -Force
$Config = ([xml](Get-Content -Path "M:\Projekte\CIsa\CIsa\CIsa.config.xml" -ErrorAction Stop)).Config  


[System.Reflection.Assembly]::LoadWithPartialName($Config.General.PartialName) | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection $Config.General.SqlConnectionString
$IntegrationServices = New-Object "$($Config.General.PartialName).IntegrationServices" $SqlConnection


Foreach($ConfigFolder in $Config.SSISDB.Folders.Folder){
    $Folder = Get-CIsaFolder  -IntegrationServicesObject $IntegrationServices -FolderName $ConfigFolder.Name -Verbose
    Remove-CIsaFolder -Folder $Folder -Verbose
}