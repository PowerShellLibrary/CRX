function Get-CRX {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory
    )

    $info = Get-CRXUpdateInfo -Id $Id
    try {
        $outputPath = Join-Path -Path $OutputDirectory -ChildPath (Split-Path -Leaf $info.Url)
        Invoke-WebRequest -Uri $info.Url -OutFile $outputPath
        Get-Item -Path $outputPath
    }
    catch {
        Write-Error $_.Exception.Message
    }
}