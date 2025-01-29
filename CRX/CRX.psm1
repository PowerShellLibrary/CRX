param(
    [parameter(Position=0,Mandatory=$false)][boolean]$UpdateChromeVersion
)

$Global:LatestStableChromeVersion = [version]"132.0.6834.159"

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

if ($UpdateChromeVersion) {
    $version = Get-LatestStableChromeVersion
    if ($version) {
        $Global:LatestStableChromeVersion = $version
    }
}

Export-ModuleMember -Function $Public.Basename