$ModulePath = "C:\Users\DBretz\Ceteris\Projekte\Intern\Integration-Services-Automation\CIsa"
Import-Module $ModulePath -Force



$SourceConnectionstring = "Data Source=DEVELSQL16;Initial Catalog=master;Integrated Security=SSPI;"
$DestinationConnectionstring = "Data Source=DEVELSQL16DE;Initial Catalog=master;Integrated Security=SSPI;"

$SourceFolderName = 'PSCisa_DBR_4'
$DestinationFolderName = 'PSCisa_DBR_499'

$SourceEnvironmentName = 'QA_4'
$DestinationEnvironmentName = 'Prod'

Invoke-CIsaCopyEnvironment  -SourceFolderName $SourceFolderName `                            -SourceEnvironmentName $SourceEnvironmentName `                            -SourceConnectionstring $SourceConnectionstring `                            -DestinationFolderName $DestinationFolderName `                            -DestinationEnvironmentName $DestinationEnvironmentName `                            -DestinationConnectionstring $DestinationConnectionstring