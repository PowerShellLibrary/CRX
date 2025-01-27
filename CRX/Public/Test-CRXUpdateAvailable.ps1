function Test-CRXUpdateAvailable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [version]$currentVersion
    )

    $updateInfo = Get-CRXUpdateInfo $Id
    if ($updateInfo) {
        $updateVersion = [version]$updateInfo.Version
        return $updateVersion -gt $currentVersion
    }
    else {
        return $false
    }
}