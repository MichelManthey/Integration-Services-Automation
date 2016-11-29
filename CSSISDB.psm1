Foreach ($Item in Get-ChildItem -Path $PSScriptRoot -Filter '*.ps1'){
    .$PSScriptRoot\$Item
}