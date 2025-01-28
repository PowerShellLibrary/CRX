function Get-CRXUpdateInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    $url = Get-CRXUpdateUrl -Id $Id
    try {
        $update = Invoke-RestMethod -Uri $url
        $app = $update.gupdate.app
        if ($app -and $app.updatecheck -and $app.updatecheck.status -ne 'noupdate') {
            return [CRXUpdateInfo]::new($app.updatecheck)
        }
    }
    catch {
        Write-Error $_.Exception.Message
    }
    return $null
}