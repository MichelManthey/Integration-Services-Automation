<#

.SYNOPSIS
TBD

.DESCRIPTION
TBD

.NOTES
Version 0.01
Author Dennis Bretz
#>
function Invoke-CSSISDBFolder
{
    [cmdletBinding()]
    param
    (
    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[Microsoft.SqlServer.Management.Sdk.Sfc.SfcInstance]$IntegrationServicesObject,

    	# TBD
		[Parameter(Mandatory=$TRUE)]
		[string]$FolderName


    )

    Begin{
        $Config = ([xml](Get-Content -Path "$PSScriptRoot\CSSISDB.config.xml" -ErrorAction Stop)).Config
    }

    Process{
        $Catalog = Get-CSSISDBCatalog -IntegrationService $IntegrationServicesObject -SSISDBName $Config.SSISDB.Name
        If(!$Catalog){
            Write-Warning -Message "TBD"
        }
        
        Write-Verbose -Message "Select Project Config"
        $ConfigFolder =  $Config.SSISDB.Folders.Folder | Where-Object "Name" -Like $FolderName
        $Folder = Get-CSSISDBFolder -IntegrationServicesObject $IntegrationServicesObject -FolderName $FolderName -Verbose
        If(!$Folder){
            Write-Verbose "$($FolderName) does not exist and will be created"
            $Folder = New-CSSISDBFolder -Catalog $Catalog -FolderName $ConfigFolder.Name -FolderDescription $ConfigFolder.Description
        }

        Foreach ($ConfigProject in $ConfigFolder.Projects.Project){
            $Status = New-CSSISDBProject -Folder $Folder -IspacSourcePath $ConfigProject.Path -Projectname $ConfigProject.Name
        }

        return($Folder)
    }

    End{}


}

