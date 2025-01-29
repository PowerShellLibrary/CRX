function Get-CRXUpdateUrl {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    $prodVersion = $Global:LatestStableChromeVersion.ToString()
    "https://clients2.google.com/service/update2/crx?prodversion=$prodVersion&acceptformat=crx2,crx3&x=id%3D$Id%26installsource%3Dondemand%26uc"
}