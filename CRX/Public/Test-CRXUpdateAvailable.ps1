function Test-CRXUpdateAvailable {
    [CmdletBinding(DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [string]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByInfo')]
        $UpdateInfo,

        [Parameter(Mandatory = $true)]
        [version]$currentVersion
    )

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $updateInfo = Get-CRXUpdateInfo -Id $Id
    }
    else {
        $updateInfo = $UpdateInfo
    }

    if ($updateInfo) {
        return $updateInfo.Version -gt $currentVersion
    }
    else {
        return $false
    }
}