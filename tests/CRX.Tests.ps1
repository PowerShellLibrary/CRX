Clear-Host
if (-not (Get-Module -Name Pester)) {
    Import-Module -Name Pester -Force
}
Import-Module .\src\CRX.psm1 -Force

Describe 'CRX.Tests' {
    Context 'Get-CRXUpdateInfo' {
        It 'Should return CRXUpdateInfo object' {
            $response = Get-CRXUpdateInfo "aoclhcccfdkjddgpaaajldgljhllhgmd"
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
                return [PSCustomObject]@{
                    Version = "2.0.0"
                    Url     = "http://example.com"
                    SHA256  = "dummyhash"
                    Status  = "ok"
                    Size    = 12345
                }
            }
            $result = Test-CRXUpdateAvailable -Id "aoclhcccfdkjddgpaaajldgljhllhgmd" -currentVersion "1.0.0"
            $result | Should -Be $true
        }

        It 'Should return false if no update is available' {
            Mock -CommandName Get-CRXUpdateInfo -ModuleName CRX -MockWith {
                return [PSCustomObject]@{
                    Version = "1.0.0"
                    Url     = "http://example.com"
                    SHA256  = "dummyhash"
                    Status  = "ok"
                    Size    = 12345
                }
            }
            $result = Test-CRXUpdateAvailable -Id "aoclhcccfdkjddgpaaajldgljhllhgmd" -currentVersion "1.0.0"
            $result | Should -Be $false
        }

        It 'Should return false if update info is null' {
            Mock -CommandName Get-CRXUpdateInfo -ModuleName CRX -MockWith { return $null }
            $result = Test-CRXUpdateAvailable -Id "aoclhcccfdkjddgpaaajldgljhllhgmd" -currentVersion "1.0.0"
            $result | Should -Be $false
        }
    }

    Context 'Get-CRX' {
        It 'Should download CRX file to specified directory' {
            Mock -CommandName Get-CRXUpdateInfo -ModuleName CRX -MockWith {
                return [PSCustomObject]@{
                    Version = "2.0.0"
                    Url     = "http://example.com/extension.crx"
                    SHA256  = "dummyhash"
                    Status  = "ok"
                    Size    = 12345
                }
            }

            Mock -CommandName Invoke-WebRequest -ModuleName CRX -MockWith {
                param ($Uri, $OutFile)
                New-Item -ItemType File -Path $OutFile -Force | Out-Null
            }

            $outputDir = ".\temp"
            $result = Get-CRX -Id "aoclhcccfdkjddgpaaajldgljhllhgmd" -OutputDirectory $outputDir

            $expectedPath = Join-Path -Path $outputDir -ChildPath "extension.crx"
            Test-Path $expectedPath | Should -Be $true
            $result | Should -BeOfType [System.IO.FileInfo]
            $result.FullName | Should -Be (Resolve-Path $expectedPath | Select-Object -ExpandProperty Path)

            Remove-Item -Path  $outputDir -Recurse -Force
        }
    }
}
