$ModulePath = "C:\Users\DBretz\Ceteris\Projekte\Intern\Integration-Services-Automation\CIsa"
Import-Module $ModulePath -Force

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection "Data Source=DEVELSQL16;Initial Catalog=master;Integrated Security=SSPI;"
$IntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $SqlConnection



Remove-CIsaEnvironment -Folder (Get-CIsaFolder -FolderName 'PSCisa_DBR' -IntegrationServices $IntegrationServices) -EnvironmentName 'Dev'
Remove-CIsaFolder -Folder (Get-CIsaFolder -FolderName 'PSCisa_DBR' -IntegrationServices $IntegrationServices)


