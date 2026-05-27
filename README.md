# The No-Error Intune Bug: 32-bit PowerShell and 64-bit Registry Paths

This case study explains how I troubleshot a silent Intune Win32 app uninstall failure where the script appeared to run successfully, but the application was not removed.

The root cause was that the Intune Win32 app uninstall process was running PowerShell in a 32-bit context, which prevented the script from reading the expected 64-bit registry uninstall path.

## Core Lesson

- [Request 64-bit PowerShell Wrapper](core-lesson/request-64bit-powershell.ps1)  
  Example wrapper that relaunches the uninstall script in 64-bit PowerShell using `Sysnative`.

- [Registry Uninstall String Lookup](core-lesson/find-uninstall-string.ps1)  
  Example showing how the uninstall string is found from registry uninstall keys.

## Project Documentation

- [Case Study](docs/case-study.md)  
  Full story of the silent uninstall failure, troubleshooting process, root cause, and fix.

- [Testing Notes](docs/testing-notes.md)  
  Technical notes on how the issue was isolated and validated.
