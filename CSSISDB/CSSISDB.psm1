Foreach ($Item in Get-ChildItem -Path $PSScriptRoot"\Public" -Filter '*.ps1'){
    Try{
        . $Item.fullname
    }Catch{
        Write-Error -Message "Failed to import $($Item.fullname)"
    }
}