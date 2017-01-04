<#

.SYNOPSIS
Creates folders with project within SSISDB using an Config.xml

.DESCRIPTION
Creates folders with project within SSISDB using an Config.xml. The projects will be created without environments variables. 
If the function is called without a folder name, all folders from the config will be created.

.EXAMPLE
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection "Data Source=.;Initial Catalog=master;Integrated Security=SSPI;"
$IntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $SqlConnection
Invoke-CIsaFolder -IntegrationServicesObject $IntegrationServices -FolderName "Microsoft_sql-server-samples" -PathToConfig "...\CIsa\CIsa.config.simple.xml"
#>
function Invoke-CIsaFolder
{
    [cmdletBinding()]
    param
    (
    	# Can be an integration services or a catalog object
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServicesObject,

    	# Defines folder to be created, if not given all folders will be created
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName,

        # Path to Config
		[Parameter(Mandatory=$TRUE)]
		[string]$PathToConfig


    )

    Begin{
        $Config = ([xml](Get-Content -Path $PathToConfig -ErrorAction Stop)).Config
    }

    Process{

        switch ($IntegrationServicesObject.GetType().Name){
            "IntegrationServices"{
                Write-Verbose -Message "Select by integration services"
                $Catalog = Get-CIsaCatalog -IntegrationServices $IntegrationServicesObject
                If(!$Catalog){
                    $Catalog = New-CIsaCatalog -IntegrationServices $IntegrationServicesObject -SSISDBPassword $Config.SSISDB.Password -SSISDBName $Config.SSISDB.Name
                }
            }
            "Catalog"{
                Write-Verbose -Message "Select by catalog"
                $Catalog = $IntegrationServicesObject
            }
            default{
                Write-Warning -Message "TBD" -ErrorAction Stop
            }
        }
        
            Write-Verbose -Message "Select project config by FolderName"
            $ConfigFolder =  $Config.SSISDB.Folders.Folder | Where-Object "Name" -Like $FolderName
            If(!$ConfigFolder){
                Write-Error -Message "$($FolderName) was not found in Config" -ErrorAction Stop
            }
            $Folder = Get-CIsaFolder -IntegrationServicesObject $IntegrationServicesObject -FolderName $FolderName
            If(!$Folder){
                Write-Verbose "$($FolderName) does not exist and will be created"
                $Folder = New-CIsaFolder -FolderName $ConfigFolder.Name -FolderDescription $ConfigFolder.Description -IntegrationServicesObject $IntegrationServicesObject
            }
            Foreach ($ConfigProject in $ConfigFolder.Projects.Project){
                $Status = New-CIsaProject -Folder $Folder -IspacSourcePath $ConfigProject.Path -ProjectName $ConfigProject.Name -ErrorAction Stop
            }
            return ($Folder)
    }

    End{}


}

