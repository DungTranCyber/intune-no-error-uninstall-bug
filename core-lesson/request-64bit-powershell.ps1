<#
.SYNOPSIS
Relaunches an Intune Win32 app script in 64-bit PowerShell.

.DESCRIPTION
Intune Win32 app install/uninstall commands may run PowerShell in a 32-bit process.
When that happens, the script may not read the expected 64-bit registry uninstall keys.

This wrapper uses Sysnative to launch the target script in 64-bit PowerShell.
#>

$PackageRoot = Split-Path -Path $MyInvocation.MyCommand.Path

# This is the real uninstall script that needs to run in 64-bit PowerShell.
$TargetScript = Join-Path $PackageRoot "uninstall.ps1"

$PowerShell64 = "$env:WINDIR\Sysnative\WindowsPowerShell\v1.0\PowerShell.exe"

if (Test-Path $PowerShell64) {
    Start-Process -FilePath $PowerShell64 -ArgumentList "-ExecutionPolicy Bypass -File `"$TargetScript`"" -Wait -NoNewWindow
}
else {
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$TargetScript`"" -Wait -NoNewWindow
}
