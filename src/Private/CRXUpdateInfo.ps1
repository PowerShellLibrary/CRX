class CRXUpdateInfo {
    [string]$Version
    [string]$Url
    [string]$SHA256
    [string]$Status
    [int]$Size

    CRXUpdateInfo($obj) {
        $this.Version = $obj.version
        $this.Url = $obj.codebase
        $this.SHA256 = $obj.hash_sha256
        $this.Status = $obj.status
        $this.Size = $obj.size
    }
}