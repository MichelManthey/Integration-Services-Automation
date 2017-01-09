<#

.SYNOPSIS
Creates Environment References to an existing project using a config.xml

.DESCRIPTION
Creates EnvironmentInfo, EnvironmentVariable and EnvironmentReference objects and links them to a ProjectInfo Object. 
Existing EnvironmentVariable objects will be overridden.

.EXAMPLE
Invoke-CIsaProjectReference -Project $Project -PathToConfig "...\CIsa\CIsa.config.simple.xml"
Invoke-CIsaProjectReference -Folder $Folder -PathToConfig "...\CIsa\CIsa.config.simple.xml" -ProjectName "Test"

#>
function Invoke-CIsaProjectReference
{
    [CmdletBinding(DefaultParametersetName='ByProject')]  
    param
    (
        # Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance CatalogFolder object.
        [Parameter(ParameterSetName='ByFolder',Mandatory=$FALSE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Folder,

    	# Can be Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance ProjectInfo Object.
		[Parameter(ParameterSetName='ByProject',Mandatory=$TRUE)]
        [Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$Project,

        # Name of the Project. Is only needed when using ByFolder.
		[Parameter(ParameterSetName='ByFolder',Mandatory=$TRUE)]
		[string]$ProjectName,

        # Path to Config.
		[Parameter(Mandatory=$TRUE)]
		[string]$PathToConfig
    )

    Begin{
        $Config = ([xml](Get-Content -Path $PathToConfig -ErrorAction Stop)).Config
        If($Project -and $Project.GetType().Name -notlike "ProjectInfo"){
            Write-Error -Message "Variable Project is not a project" -ErrorAction Stop
        }

        If($Folder -and $Folder.GetType().Name -notlike "CatalogFolder" ){
            Write-Error -Message "Variable Folder is not a catalogfolder" -ErrorAction Stop
        }

        if($Project){
            $Folder = $Project.Parent
        }

        if($Folder){
            $Project = Get-CIsaProject -Folder $Folder -ProjectName $ProjectName
            If(!$Project){
                Write-Error "Project not found within Folder $($Folder.Name)" -ErrorAction Stop
            }
        }

        try{
           $Folder.Refresh()
        }Catch{
           Write-Error -Message "Problem refreshing Folder." -ErrorAction Stop -RecommendedAction "Maybe Folder is not synchronous with server side. Try refresh Integration Services"
        }
    }

    Process{
       Write-Verbose -Message "Select Project Config $($Project) for Folder $($Folder)"
       $ConfigProject = ($Config.SSISDB.Folders.Folder | Where-Object "Name" -Like $Folder.Name).Projects.Project | Where-Object "Name" -Like $Project.Name
       
       Write-Verbose -Message "Create Project Environments"
       Foreach($ID in $ConfigProject.References.Reference.EnvId){
           Write-Verbose -Message "Select ID: $($ID)"
           $ConfigEnvironment = $Config.SSISDB.Environments.Environment | Where-Object "EnvId" -Like $ID
           Write-Verbose -Message "Get Environment $($ConfigEnvironment.Name) from Folder $($Folder.Name) with Id $($ConfigEnvironment.ID)"
           
           $Environment = Get-CIsaEnvironment -Folder $Folder -EnvironmentName $ConfigEnvironment.Name
           if(!$Environment){
               Write-Verbose -Message "Environment not existing, will be created"
               $Environment = New-CIsaEnvironment -Folder $Folder -EnvironmentName $ConfigEnvironment.Name
           }
       
           Write-Verbose -Message "Creates Variables"
           Foreach($ConfigVariable in $ConfigEnvironment.Variables.Variable){
               $Variable = Get-CIsaEnvironmentVariable -Environment $Environment -VariableName $ConfigVariable.Name
               if(!$Variable){
                   $Variable = New-CIsaEnvironmentVariable -Environment $Environment -VariableName $ConfigVariable.Name -VariableType $ConfigVariable.Type -VariableDefaultValue $ConfigVariable.DefaultValue -VariableSensitivity $ConfigVariable.Sensitivity -VariableDescription $ConfigVariable.Description -Override
               }
           }
           $Environment.Alter()
       }
       
       
       Write-Verbose -Message "Creates references between project and linked Environments"
       Foreach($ConfigReference in $ConfigProject.References.Reference){
           $TmpEnvironment = $Config.SSISDB.Environments.Environment | Where-Object "EnvId" -Like $ConfigReference.EnvId
           $EnvironmentReference = Get-CIsaProjectReference -Project $Project -EnvironmentName $TmpEnvironment.Name -FolderName $Folder.Name
           if(!$EnvironmentReference){
               New-CIsaProjectReference -Folder $Folder -EnvironmentName $TmpEnvironment.Name -ProjectName $Project.Name
           }
           
           
           $TmpReference = $Config.SSISDB.References.Reference| Where-Object "RefId" -Like $ConfigReference.RefId
           Foreach($ConfigVariableProject in $TmpReference.Variables.Variable){
               Set-CIsaEnvironmentVariable -Project $Project -ProjectParamName $ConfigVariableProject.ProjectParam -VariableName $ConfigVariableProject.VariableName
           }
           $Project.Alter()
           $EnvironmentReference = Get-CIsaProjectReference -Folder $Folder -EnvironmentName $TmpEnvironment.Name -ProjectName $Project.Name
           $EnvironmentReference.Refresh()
       }        
    }

    End{}


}

