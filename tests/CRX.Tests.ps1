if (-not (Get-Module -Name Pester)) {
    Import-Module -Name Pester -Force
}
Import-Module .\CRX\CRX.psm1 -Force

Describe 'CRX Module Import' {
    BeforeAll {
        # hardcoded version - shipped with the module
        $chromeVersion = [version]"132.0.6834.159"
    }

    Context 'When UpdateChromeVersion parameter is used' {
        It 'Should get the latest stable Chrome version' {
            Import-Module .\CRX\CRX.psm1 -ArgumentList $true -Force

            $Global:LatestStableChromeVersion | Should -BeOfType [version]
            $Global:LatestStableChromeVersion -gt $chromeVersion | Should -Be $true
        }

        It 'Should not get the latest stable Chrome version' {
            Import-Module .\CRX\CRX.psm1 -ArgumentList $false -Force

            $Global:LatestStableChromeVersion | Should -BeOfType [version]
            $Global:LatestStableChromeVersion.ToString() | Should -Be $chromeVersion
        }
    }

    Context 'When UpdateChromeVersion parameter is not used' {
        It 'Should not get the latest stable Chrome version' {
            Import-Module .\CRX\CRX.psm1 -Force

            $Global:LatestStableChromeVersion | Should -BeOfType [version]
            $Global:LatestStableChromeVersion.ToString() | Should -Be $chromeVersion
        }
    }
}

Describe 'Get-LatestStableChromeVersion' {
    Context 'When API call is successful' {
        It 'Should return a valid version' {
            Mock -CommandName Invoke-RestMethod -ModuleName CRX -MockWith {
                return @{
                    channel   = 'Stable'
                    milestone = 132
                    platform  = "Windows"
                    version   = "132.0.6834.160"
                }
            }

            $result = Get-LatestStableChromeVersion
            $result | Should -BeOfType [version]
            $result.ToString() | Should -Be "132.0.6834.160"
        }
    }

    Context 'When API call fails' {
        It 'Should return $null' {
            Mock -CommandName Invoke-RestMethod -ModuleName CRX -MockWith {
                throw "API call failed"
            }

            $result = Get-LatestStableChromeVersion
            $result | Should -Be $null
        }
    }
}

Describe 'CRX.Tests' {
    BeforeAll {
        $testUrl = 'https://localhost.com/crx/blobs/ASuc5ohLVu-itAJfZqe6NgPkB0pCREbOH49PhxJq4pMdp7MWQx-ycGQt8dsD8WUSM_dTlB5sLwXljaUve7GTKh485NrRlNGdmT7O5aT9uS4R9jmIqNJBAMZSmuV9IZ0e0VV7jGd-rrI-YR5eoIra2Q/AOCLHCCCFDKJDDGPAAAJLDGLJHLLHGMD_4_0_0_0.crx'
        $testExtensionId = 'aoclhcccfdkjddgpaaajldgljhllhgmd'
    }

    Context 'Get-CRXUpdateInfo' {
        It 'Should return CRXUpdateInfo object' {
            $response = Get-CRXUpdateInfo $testExtensionId
            $response.Url | Should -Not -BeNullOrEmpty
            $response.Version | Should -Not -BeNullOrEmpty
        }

        It 'Should return null for invalid extension ID' {
            $response = Get-CRXUpdateInfo "invalid"
            $response | Should -BeNullOrEmpty
        }

        It 'Should return null when no update is available' {
            Mock -CommandName Invoke-RestMethod -ModuleName CRX -MockWith {
                param ($Uri, $OutFile)
                return @{
                    gupdate = @{
                        app = @{
                            updatecheck = @{
                                status = 'noupdate'
                            }
                        }
                    }
                }
            }

            $result = Get-CRXUpdateInfo -Id $testExtensionId
            $result | Should -Be $null
        }
    }

    Context 'Test-CRXUpdateAvailable' {
        It 'Should return true if update is available' {
            Mock -CommandName Get-CRXUpdateInfo -ModuleName CRX -MockWith {
                New-CRXUpdateInfo @{
                    version     = "2.0.0"
                    codebase    = $testUrl
                    hash_sha256 = "dummyhash"
                    status      = "ok"
                    size        = 12345
                }
            }
            $result = Test-CRXUpdateAvailable -Id $testExtensionId -currentVersion "1.0.0"
            $result | Should -Be $true
        }

        It 'Should return false if no update is available' {
            Mock -CommandName Get-CRXUpdateInfo -ModuleName CRX -MockWith {
                return New-CRXUpdateInfo @{
                    version     = "2.0.0"
                    codebase    = $testUrl
                    hash_sha256 = "dummyhash"
                    status      = "ok"
                    size        = 12345
                }
            }
            $result = Test-CRXUpdateAvailable -Id $testExtensionId -currentVersion "2.0.0"
            $result | Should -Be $false
        }

        It 'Should return false if update info is null' {
            Mock -CommandName Get-CRXUpdateInfo -ModuleName CRX -MockWith { return $null }
            $result = Test-CRXUpdateAvailable -Id $testExtensionId -currentVersion "1.0.0"
            $result | Should -Be $false
        }
    }

    Context 'Get-CRX' {
        It 'Should download CRX file to specified directory' {
            Mock -CommandName Get-CRXUpdateInfo -ModuleName CRX -MockWith {
                return New-CRXUpdateInfo @{
                    version     = "2.0.0"
                    codebase    = $testUrl
                    hash_sha256 = "dummyhash"
                    status      = "ok"
                    size        = 12345
                }
            }

            Mock -CommandName Invoke-WebRequest -ModuleName CRX -MockWith {
                param ($Uri, $OutFile)
                New-Item -ItemType File -Path $OutFile -Force | Out-Null
            }

            $outputDir = ".\temp"
            $result = Get-CRX -Id $testExtensionId -OutputDirectory $outputDir

            $expectedPath = Join-Path -Path $outputDir -ChildPath "$testExtensionId`_4_0_0_0.crx"
            Test-Path $expectedPath | Should -Be $true
            $result | Should -BeOfType [System.IO.FileInfo]
            $result.FullName | Should -Be (Resolve-Path $expectedPath | Select-Object -ExpandProperty Path)

            Remove-Item -Path  $outputDir -Recurse -Force
        }
    }
}

InModuleScope CRX {
    Describe 'Get-CRXUpdateUrl' {
        BeforeAll {
            $Global:LatestStableChromeVersion = [version]"128.0.0.256"
            $testExtensionId = "aoclhcccfdkjddgpaaajldgljhllhgmd"

        }

        It 'Should return the correct update URL' {
            $expectedUrl = "https://clients2.google.com/service/update2/crx?prodversion=128.0.0.256&acceptformat=crx2,crx3&x=id%3D$testExtensionId%26installsource%3Dondemand%26uc"
            $result = Get-CRXUpdateUrl -Id $testExtensionId
            $result | Should -Be $expectedUrl
        }
    }
}