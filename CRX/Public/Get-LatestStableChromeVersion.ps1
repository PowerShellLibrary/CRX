function Get-LatestStableChromeVersion {
    $uri = "https://chromiumdash.appspot.com/fetch_releases?channel=Stable&platform=Windows&num=1"
    try {
        $data = Invoke-RestMethod -Uri $uri
        $available = [version]$data.version
    } catch {
        Write-Warning "Failed to retrieve the latest stable Chrome version. Please check your internet connection."
        return $null
    }
    $available
}