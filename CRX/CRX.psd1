
@{
    RootModule        = 'CRX.psm1'
    ModuleVersion     = '0.1.1'
    GUID              = 'b5433b6c-b423-4049-8c5e-b3a50566fcf2'
    Author            = 'Alan Plocieniak'
    CompanyName       = 'Alan Plocieniak'
    Copyright         = '(c) 2025 Alan Plocieniak. All rights reserved.'
    Description       = 'Module for downloading CRX (extension package) for Chromium-based browsers.'
    PowerShellVersion    = '5.1'
    CompatiblePSEditions = 'Desktop', 'Core'
    FunctionsToExport = '*'
    PrivateData          = @{
        PSData = @{
            Tags       = @('powershell', 'crx', 'ps', 'power-shell', 'CRX', 'chrome', 'extension' )
            LicenseUri = 'https://github.com/PowerShellLibrary/CRX/blob/master/LICENSE'
            ProjectUri = 'https://github.com/PowerShellLibrary/CRX'
        }
    }
}
