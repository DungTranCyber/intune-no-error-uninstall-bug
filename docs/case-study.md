# Case Study: The No-Error Intune Bug

This case study focuses on a silent uninstall failure during an Intune Win32 app deployment.

## Why This Case Was Difficult

This was one of the more frustrating Intune issues I worked on because the script did not fail with a clear error.

The uninstall script appeared to run, but nothing happened after the registry detection section. There was no obvious PowerShell error pointing to the root cause.

This made the issue harder than a normal script failure. I had to isolate the problem manually by removing sections of the script from the bottom upward, testing after each change, and watching where the output stopped.

That process eventually narrowed the issue down to registry access and led me to the 32-bit vs 64-bit PowerShell behavior in Intune Win32 app deployments.

## Problem

The script was designed to find the application's uninstall string from the Windows registry and use that uninstall command to remove the application.

The issue was that the uninstall script could not read the expected 64-bit registry uninstall path when running through Intune.

## Root Cause

The Intune Win32 app process was running PowerShell in a 32-bit context.

Because of that, the script could not properly access the 64-bit registry uninstall path:

`HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall`

The uninstall logic depended on finding values like:

- DisplayName
- DisplayVersion
- UninstallString
- QuietUninstallString

When the script could not read the expected registry location, the uninstall variable was empty and the rest of the uninstall logic did not behave as expected.

## Troubleshooting Method

To isolate the issue, I reduced the script piece by piece from the bottom upward and tested after each change.

Eventually, I found that the script stopped producing useful output around the registry detection/uninstall string section.

That narrowed the problem down to registry access instead of the uninstall command itself.

## Fix

The fix was to relaunch the uninstall script using 64-bit PowerShell through `Sysnative`.

`Sysnative` allows a 32-bit process to access the real 64-bit `System32` PowerShell path.

The wrapper script launches the real uninstall script in 64-bit PowerShell so it can read the correct registry path.

## What This Project Demonstrates

- Intune Win32 app troubleshooting
- 32-bit vs 64-bit PowerShell behavior
- Registry-based uninstall logic
- Silent failure investigation
- Script isolation testing
- Deployment troubleshooting using logs
