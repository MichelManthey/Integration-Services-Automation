<#

.SYNOPSIS
Creates a folder with all projects using an config.xml

.DESCRIPTION
Creates a CatalogFolder with all projects using an config.xml If a ProjectName is given only this project will be created.
The projects will be created without environments variables.
They can either be created via an IntegrationServices object or via a Catalog object.
If Invoke-CIsaFolder is used ByIntegrationServices a catalog will be created if it does not exist.
If the Folder exist, projects within config will be added.


.EXAMPLE
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection "Data Source=.;Initial Catalog=master;Integrated Security=SSPI;"
$IntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $SqlConnection
Invoke-CIsaFolder -IntegrationServices $IntegrationServices -FolderName "Microsoft_sql-server-samples" -PathToConfig "...\CIsa\CIsa.config.simple.xml"
#>
function Invoke-CIsaFolder
{
    [CmdletBinding(DefaultParametersetName='ByCatalog')] 
    param
    (
        #Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance Catalog object
        [Parameter(ParameterSetName='ByCatalog',Mandatory=$TRUE)]
        [Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Catalog,

        #Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance IntegrationServices object
		[Parameter(ParameterSetName='ByIntegrationServices',Mandatory=$TRUE)]
        [Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServices,

   	    # Defines folder which should be created
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName,

   	    # Defines project which should be created. If not given all Projects will be created.
		[Parameter(Mandatory=$FALSE)]
		[string]$ProjectName,        

        # Path to Config
		[Parameter(Mandatory=$TRUE)]
		[string]$PathToConfig


    )

    Begin{
        $Config = ([xml](Get-Content -Path $PathToConfig -ErrorAction Stop)).Config
        If($Catalog -and $Catalog.GetType().Name -notlike "Catalog" ){
            Write-Error -Message "Variable Catalog is not a Catalog" -ErrorAction Stop
        }


        If($IntegrationServices -and $IntegrationServices.GetType().Name -notlike "IntegrationServices" ){
            Write-Error -Message "Variable IntegrationServices is not a IntegrationServices" -ErrorAction Stop
        }elseif($IntegrationServices -and $IntegrationServices.GetType().Name -like "IntegrationServices" ){
            Write-Verbose -Message "Select catalog by IntegrationServices"
            $Catalog = Get-CIsaCatalog -IntegrationServices $IntegrationServices
            If(!$Catalog){
                $Catalog = New-CIsaCatalog -IntegrationServices $IntegrationServices -SSISDBPassword $Config.SSISDB.Password -SSISDBName $Config.SSISDB.Name
            }
        }
    }

    Process{
            Write-Verbose -Message "Select project config by FolderName"
            $ConfigFolder =  $Config.SSISDB.Folders.Folder | Where-Object "Name" -Like $FolderName

            If(!$ConfigFolder){
                Write-Error -Message "$($FolderName) was not found in Config" -ErrorAction Stop
            }
            $Folder = Get-CIsaFolder -IntegrationServices $IntegrationServices -FolderName $FolderName
            If(!$Folder){
                Write-Verbose "$($FolderName) does not exist and will be created"
                $Folder = New-CIsaFolder -FolderName $ConfigFolder.Name -FolderDescription $ConfigFolder.Description -IntegrationServices $IntegrationServices
            }

            If($ProjectName){
                Write-Verbose -Message "Select one project config by ProjectName"
                $ProjectObjects =  $ConfigFolder.Projects.Project | Where-Object "Name" -Like $ProjectName
                Write-Error -Message "Project was not found within folder config" -ErrorAction Stop
            }else{
                Write-Verbose -Message "Select all projects"
                $ProjectObjects =  $ConfigFolder.Projects.Project
            }

            Foreach ($ConfigProject in $ProjectObjects){
                $Status = New-CIsaProject -Folder $Folder -IspacSourcePath $ConfigProject.Path -ProjectName $ConfigProject.Name -ErrorAction Stop
            }
            return ($Folder)
    }

    End{}


}

