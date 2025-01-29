# CRX
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/CRX?label=CRX&labelColor=373e45&color=blue&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciICB2aWV3Qm94PSIwIDAgNDggNDgiIHdpZHRoPSI0OHB4IiBoZWlnaHQ9IjQ4cHgiPjxwYXRoIGZpbGw9IiMwMjc3YmQiIGQ9Ik0xOS44NDcsNDEuOTU2Yy01LjYyOS0wLjAwMi0xMS4yNTksMC4wMjQtMTYuODg4LTAuMDEzYy0yLjg1NS0wLjAxOS0zLjM3NC0wLjctMi43MzEtMy41MjUgYzIuMTc4LTkuNTgsNC40MjctMTkuMTQzLDYuNTU3LTI4LjczNEM3LjM1Niw3LjExMiw4LjU4OCw1Ljk3NSwxMS4zMTIsNkMyMi41Nyw2LjEwNiwzMy44MjksNi4wMzQsNDUuMDg4LDYuMDQ2IGMyLjgyNCwwLjAwMywzLjI5OCwwLjYxNCwyLjY2NCwzLjUxMWMtMi4wNTgsOS40MDYtNC4xMjksMTguODA5LTYuMjM2LDI4LjIwM2MtMC43ODksMy41MTYtMS42OTcsNC4xODctNS4zNTMsNC4xOTUgQzMwLjcyNCw0MS45NjYsMjUuMjg1LDQxLjk1OCwxOS44NDcsNDEuOTU2eiIvPjxwYXRoIGZpbGw9IiNmYWZhZmEiIGQ9Ik0yNS4wNTcgMjMuOTIyYy0uNjA4LS42ODctMS4xMTQtMS4yNjctMS41MzEtMS43MzItMi40My0yLjcyOC00LjY1Ni01LjI3LTcuMDYzLTcuODY5LTEuMTAyLTEuMTg5LTEuNDUzLTIuMzQ0LS4xMy0zLjUxOCAxLjMwNy0xLjE2IDIuNTkyLTEuMDU4IDMuNzkxLjI3NyAzLjM0IDMuNzE3IDYuNjc2IDcuNDM4IDEwLjA3MSAxMS4xMDQgMS4yNjggMS4zNjkuOTcyIDIuMy0uNDI0IDMuMzE1LTUuMzU5IDMuODk1LTEwLjY4NyA3LjgzMy0xNi4wMSAxMS43NzgtMS4xOTYuODg3LTIuMzM3IDEuMTA5LTMuMzA0LS4yMDEtMS4wNjYtMS40NDUtLjA4LTIuMzA1IDEuMDI2LTMuMTE0IDMuOTU1LTIuODkzIDcuOTAzLTUuNzk4IDExLjgzNC04LjcyNUMyMy44NjUgMjQuODMgMjQuNTk1IDI0LjI2NyAyNS4wNTcgMjMuOTIyek0yMS43NSAzN0MyMC42MjUgMzcgMjAgMzYgMjAgMzVzLjYyNS0yIDEuNzUtMmM0LjIyNCAwIDYuMTEyIDAgOS41IDAgMS4xMjUgMCAxLjc1IDEgMS43NSAycy0uNjI1IDItMS43NSAyQzI5LjEyNSAzNyAyNSAzNyAyMS43NSAzN3oiLz48L3N2Zz4=)](https://www.powershellgallery.com/packages/CRX)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?labelColor=373e45)](LICENSE)
[![Build Status](https://img.shields.io/github/actions/workflow/status/PowerShellLibrary/CRX/test.yml?branch=master&logo=github&labelColor=373e45&label=Pester)](https://github.com/PowerShellLibrary/CRX/actions/workflows/test.yml)

Module for downloading CRX (extension package) for Chromium-based browsers.


## How to Use

To use the CRX module, you need to install it from the PowerShell Gallery and then import it into your PowerShell session.

### Installation

```powershell
Install-Module -Name CRX
Import-Module -Name CRX
```

> [!NOTE]
> **Latest stable chrome version is hardcoded in `$Global:LatestStableChromeVersion` by default**
>
> You can update it manually or use `-ArgumentList` during module import so the latest version will be automatically fetched from https://chromiumdash.appspot.com
>
> `Import-Module CRX -ArgumentList $true`

### Example Usage
**Downloads the CRX file for a specified extension.**
```powershell
Get-CRX -ExtensionId "[EXTENSION_ID]"
```

**Check if an update is available for a specific extension**
```powershell
Test-CRXUpdateAvailable -ExtensionId "[EXTENSION_ID]"
```

**Get update information for a specific extension**
```powershell
Get-CRXUpdateInfo -ExtensionId "[EXTENSION_ID]"
```