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

# Testing Notes

## What Made This Hard

...

## Key Discovery

...

## Validation Steps

...

## Troubleshooting Process

Because there was no clear error, I had to isolate the issue manually.

I used two methods:

1. Added `Write-Host` output throughout the script while using transcript/logging to see which steps were reached.
2. Removed chunks of the uninstall script from the bottom upward and tested after each change.

The script appeared to run, but the output stopped around the registry lookup section. When I checked the variable that should have contained the installed application information, it was empty.

That was confusing because when I manually opened normal PowerShell and checked the same registry path, the uninstall string existed.

The key discovery came when I opened 32-bit PowerShell manually and tested the same registry lookup. In that context, the script could not see the expected 64-bit registry uninstall path.

That confirmed the issue was not the uninstall command itself. The issue was the PowerShell execution context used by Intune.

## Lesson

...

A script can “run successfully” and still fail logically.

This case taught me to test not only whether PowerShell returns an error, but whether each variable contains the expected data.
