$Public = @( Get-ChildItem -Path $PSScriptRoot\Public -Recurse -Filter *.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private -Recurse -Filter *.ps1 -ErrorAction SilentlyContinue )

Foreach ($import in @($Private + $Public )) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}
Export-ModuleMember -Function $Public.Basename