$Functions = @{
    Public  = @(Get-ChildItem "$PSScriptRoot\Functions\Public\" -File -Recurse -Filter "*.ps1")
    Private = @(Get-ChildItem "$PSScriptRoot\Functions\Private\" -File -Recurse -Filter "*.ps1")
}
($Functions.Public + $Functions.Private) | ForEach-Object {
    Write-Verbose "Dotting $($_.FullName)"
    . "$($_.FullName)"
}
Export-ModuleMember -Function ($Functions.Public.BaseName) -Alias *