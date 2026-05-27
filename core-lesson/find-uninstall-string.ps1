<#
.SYNOPSIS
Example registry-based uninstall string lookup.

.DESCRIPTION
This example shows the type of registry lookup that failed silently when the script
was executed in a 32-bit PowerShell context by Intune Win32 app deployment.

The goal is to find the application uninstall command from Windows uninstall keys.
#>

$appName = "Example App"

$registryPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
)

$install = Get-ChildItem -Path $registryPaths -ErrorAction SilentlyContinue |
    Get-ItemProperty -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -like "*$appName*" }

if (-not $install) {
    Write-Output "$appName was not found in registry uninstall keys."
    exit 1
}

Write-Output "Found: $($install.DisplayName)"
Write-Output "Version: $($install.DisplayVersion)"
Write-Output "UninstallString: $($install.UninstallString)"
Write-Output "QuietUninstallString: $($install.QuietUninstallString)"
