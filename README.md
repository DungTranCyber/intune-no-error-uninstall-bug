# The No-Error Intune Bug: 32-bit PowerShell and 64-bit Registry Paths

This case study explains how I troubleshot a silent Intune Win32 app uninstall failure where the script appeared to run successfully, but the application was not removed.

The root cause was that the Intune Win32 app uninstall process was running PowerShell in a 32-bit context, which prevented the script from reading the expected 64-bit registry uninstall path.
