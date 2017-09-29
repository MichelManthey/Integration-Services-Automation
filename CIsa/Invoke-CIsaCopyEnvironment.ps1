<#
.SYNOPSIS
Copy an existing environment

.DESCRIPTION
Copy an existing environment to a given folder. The copy function can be used across servers.

.EXAMPLE
#>
function Invoke-CIsaCopyEnvironment
{

    [CmdletBinding()]  
    param
    (
        
        # Name of the folder.
        [Parameter(Mandatory=$TRUE)]
        [String]$SourceFolderName,

        # Name of the source environment.
		[Parameter(Mandatory=$TRUE)]
		[string]$SourceEnvironmentName,

        # Name of the source environment.
		[Parameter(Mandatory=$TRUE)]
		[string]$SourceConnectionstring = "Data Source=.;Initial Catalog=master;Integrated Security=SSPI;",

        # Name of the folder.
        [Parameter(Mandatory=$TRUE)]
        [String]$DestinationFolderName,

        # Name of the source environment.
		[Parameter(Mandatory=$TRUE)]
		[string]$DestinationEnvironmentName,

        # Name of the source environment.
		[Parameter(Mandatory=$TRUE)]
		[string]$DestinationConnectionstring = "Data Source=.;Initial Catalog=master;Integrated Security=SSPI;"

    )

    Begin{
        $StartTime = Get-Date -UFormat "%T"
        Write-Verbose -Message "$($StartTime) - Start Function $($MyInvocation.MyCommand)"

        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management.IntegrationServices") | Out-Null;
        $SourceSqlConnection = New-Object System.Data.SqlClient.SqlConnection $SourceConnectionstring
        $SourceIntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $SourceSqlConnection

        $DestinationSqlConnection = New-Object System.Data.SqlClient.SqlConnection $DestinationConnectionstring
        $DestinationIntegrationServices = New-Object "Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices" $DestinationSqlConnection

    }

    Process{
        $SourceFolder      = Get-CIsaFolder -IntegrationServices $SourceIntegrationServices -FolderName $SourceFolderName
        If(!$SourceFolder){
           Write-Error "Source folder $($SourceFolderName) does not exists'" -ErrorAction Stop
        }
        $DestinationFolder = Get-CIsaFolder -IntegrationServices $DestinationIntegrationServices -FolderName $DestinationFolderName
        
        If(!$DestinationFolder){
            Write-Warning -Message "Destination folder: $($DestinationFolderName), does not exists and will be created"
            New-CIsaFolder -IntegrationServices $DestinationIntegrationServices -FolderName $DestinationFolderName
            $DestinationFolder = Get-CIsaFolder -IntegrationServices $DestinationIntegrationServices -FolderName $DestinationFolderName
    	}

    
        $SourceEnvironment = Get-CIsaEnvironment -Folder $SourceFolder -EnvironmentName $SourceEnvironmentName
        If(!$SourceEnvironment){
           Write-Error "Source environment $($SourceEnvironmentName) does not exists'" -ErrorAction Stop
        }

        #TBD what happens when source are multiple environments
        if($SourceEnvironment.Count -ne 1){
            Write-Error -Message "Source Environment not singular, count: $($SourceEnvironment.Count)" -ErrorAction Stop
        }

        $DestinationEnvironment = Get-CIsaEnvironment -Folder $DestinationFolder -EnvironmentName $DestinationEnvironmentName
        If(!$DestinationEnvironment){
            Write-Warning -Message "Destination environment: $($DestinationEnvironmentName), does not exists and will be created"
            New-CIsaEnvironment -Folder $DestinationFolder -EnvironmentName $DestinationEnvironmentName -EnvironmentDescription $SourceEnvironment.Description
            $DestinationEnvironment = Get-CIsaEnvironment -Folder $DestinationFolder -EnvironmentName $DestinationEnvironmentName
    	}

        $SourceVariables = Get-CIsaEnvironmentVariable -Environment $SourceEnvironment

        Foreach($var in $SourceVariables){
            if($var.Sensitive -like "true"){
                New-CIsaEnvironmentVariable -Environment $DestinationEnvironment `
                                        -VariableName $var.Name `
                                        -VariableType $var.Type `
                                        -VariableDefaultValue ' ' `
                                        -VariableDescription $var.Description `                                        -Override `
                                        -VariableSensitivity
            }else{
                New-CIsaEnvironmentVariable -Environment $DestinationEnvironment `
                                        -VariableName $var.Name `
                                        -VariableType $var.Type `
                                        -VariableDefaultValue $var.Value `
                                        -VariableDescription $var.Description `                                        -Override
            }
        }
                          

    }

    End{
        $SourceSqlConnection.close()
        $DestinationSqlConnection.Close()

        $EndTime = Get-Date -UFormat "%T"
        $Timespan = NEW-TIMESPAN -Start $StartTime -End $EndTime
        Write-Verbose -Message "Finished $($EndTime) with $($Timespan.TotalSeconds) seconds"
    }


}

