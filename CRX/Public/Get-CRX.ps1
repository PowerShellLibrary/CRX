function Get-CRX {
    [CmdletBinding(DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [string]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByInfo')]
        $UpdateInfo,

        [Parameter(Mandatory = $true)]
        [string]$OutputDirectory
    )

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $info = Get-CRXUpdateInfo -Id $Id
    }
    else {
        $info = $UpdateInfo
    }

    if ($null -eq $info) {
        return $null
    }

    try {
        $outputPath = Join-Path -Path $OutputDirectory -ChildPath $info.FileName
        Invoke-WebRequest -Uri $info.Url -OutFile $outputPath
        Get-Item -Path $outputPath
    }
    catch {
        Write-Error $_.Exception.Message
    }
}