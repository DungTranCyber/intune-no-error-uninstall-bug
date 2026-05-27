# Testing Notes

## What Made This Hard

The uninstall script did not fail loudly. It appeared to run, but the application stayed installed.

There was no useful error message. Even with `try/catch`, `Start-Transcript`, and extra output, the script did not clearly show where the problem was.

This made the issue confusing because the same registry lookup worked when I ran it manually in a normal PowerShell console on the machine. The uninstall string existed in the registry, but when the script ran through the Intune Win32 app uninstall command, the result was empty.

## Troubleshooting Process

Because there was no clear error, I had to isolate the issue manually.

I used two methods:

1. Added `Write-Host` output throughout the script while using transcript/logging to see which steps were reached.
2. Removed chunks of the uninstall script from the bottom upward and tested after each change.

The script appeared to run, but the output stopped around the registry lookup section. When I checked the variable that should have contained the installed application information, it was empty.

That narrowed the issue down to registry detection instead of the uninstall command itself.

## Key Discovery

The key clue was that the Intune deployment method is called **Win32 app**.

That made me question whether the script was running in a 32-bit PowerShell context.

To test this, I opened 32-bit PowerShell manually on the same computer and ran the same registry lookup. In 32-bit PowerShell, the expected 64-bit uninstall registry path returned no output.

Then I tested again in 64-bit PowerShell, and the registry lookup worked.

That confirmed the issue was not the application, the uninstall string, or the registry path itself. The issue was the PowerShell execution context used by Intune.

## Registry Path Involved

The script needed to read uninstall values from:

`HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall`

The important values were:

- `DisplayName`
- `DisplayVersion`
- `UninstallString`
- `QuietUninstallString`

When Intune ran the uninstall command in a 32-bit PowerShell context, the script could not read the expected 64-bit registry uninstall keys.

## Validation Steps

I tested by:

1. Running parts of the script manually.
2. Adding output before and after the registry lookup.
3. Checking whether the uninstall variable was empty.
4. Removing script sections from the bottom upward.
5. Comparing behavior between 32-bit and 64-bit PowerShell.
6. Testing `Sysnative` to relaunch the uninstall script in 64-bit PowerShell.

To confirm the PowerShell process architecture, I added these checks into the uninstall script inside the Intune Win32 app package:

```powershell
[System.IntPtr]::Size
[Environment]::Is64BitProcess
```
Expected results:

```text
[System.IntPtr]::Size
4 = 32-bit PowerShell
8 = 64-bit PowerShell

[Environment]::Is64BitProcess
False = 32-bit PowerShell
True  = 64-bit PowerShell
```

When the script ran through the Intune Win32 app uninstall command, the log showed it was running in a 32-bit PowerShell process.

When I ran the same logic manually in normal local PowerShell, it ran in 64-bit PowerShell and could read the expected 64-bit registry uninstall path.

This confirmed the root cause: the script logic was correct, but Intune was executing it in a different PowerShell architecture context.

## Lesson

A script can “run successfully” and still fail logically.

This case taught me to test not only whether PowerShell returns an error, but whether each important variable contains the expected data.

It also taught me that no-error failures can be harder to troubleshoot than visible errors, because the script may continue running while the actual logic silently fails.
