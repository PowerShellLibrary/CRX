class CRXUpdateInfo {
    [string]$Id
    [string]$FileName
    [version]$Version
    [string]$Url
    [string]$SHA256
    [string]$Status
    [int]$Size

    CRXUpdateInfo($obj) {
        if ($obj.version.Contains('.')) {
            $this.Version = $obj.version
        }
        else {
            $this.Version = $obj.version + ".0"
        }

        $this.Url = $obj.codebase
        $this.FileName = Split-Path -Leaf $this.Url.ToLower()
        $this.Id = $this.FileName.Substring(0, 32)
        $this.SHA256 = $obj.hash_sha256
        $this.Status = $obj.status
        $this.Size = $obj.size
    }
}

# work around for ps module class export issues
function New-CRXUpdateInfo($ob) {
    return [CRXUpdateInfo]::new($ob)
}