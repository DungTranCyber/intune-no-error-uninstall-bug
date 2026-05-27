# Testing Notes

## What Made This Hard

The uninstall script did not fail loudly. It appeared to run, but the application stayed installed.

There was no useful error message, so I had to troubleshoot by reducing the script section by section until I found where output stopped.

## Key Discovery

The issue happened around the registry detection section.

The script needed to read uninstall values from:

`HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall`

But when Intune ran the Win32 app uninstall command, PowerShell was running in a 32-bit context.

That caused the script to miss the expected 64-bit uninstall registry keys.

## Validation Steps

I tested by:

1. Running parts of the script manually.
2. Removing sections from the bottom upward.
3. Adding output before and after the registry lookup.
4. Checking whether the uninstall variable was empty.
5. Comparing 32-bit and 64-bit PowerShell behavior.
6. Testing `Sysnative` to relaunch the script in 64-bit PowerShell.

## Lesson

A script can “run successfully” and still fail logically.

This case taught me to test not only whether PowerShell returns an error, but whether each variable contains the expected data.
