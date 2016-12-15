Foreach ($Item in Get-ChildItem -Path $PSScriptRoot"\Helper" -Filter '*.ps1'){
    Try{
        . $Item.fullname
    }Catch{
        Write-Error -Message "Failed to import $($Item.fullname)"
    }
}

Foreach ($Item in Get-ChildItem -Path $PSScriptRoot -Filter '*.ps1'){
    Try{
        . $Item.fullname
    }Catch{
        Write-Error -Message "Failed to import $($Item.fullname)"
    }
}