if (-not (Get-Module -Name Pester)) {
    Import-Module -Name Pester -Force
}
Import-Module .\CRX\CRX.psm1 -Force

Describe 'CRX.Tests' {
    BeforeAll{
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
