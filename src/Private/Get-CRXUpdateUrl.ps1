function Get-CRXUpdateUrl {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    "https://clients2.google.com/service/update2/crx?prodversion=131.0.6778.205&acceptformat=crx2,crx3&x=id%3D$Id%26installsource%3Dondemand%26uc"
}