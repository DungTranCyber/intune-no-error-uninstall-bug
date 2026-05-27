# Lessons Learned

## 1. No-error failures can be harder than visible errors

This issue was difficult because the script appeared to run successfully, but the application was not removed. There was no clear PowerShell error pointing to the root cause.

## 2. Intune execution context matters

A script can behave differently in Intune than it does during manual testing. In this case, the uninstall script ran in a 32-bit PowerShell context and could not read the expected 64-bit registry uninstall keys.

## 3. Registry-based uninstall logic must account for architecture

The uninstall string may exist in different registry locations depending on whether the application is 32-bit, 64-bit, per-machine, or per-user.

## 4. Troubleshooting requires isolation

I isolated the issue by reducing the script section by section and testing where the output stopped. This narrowed the problem to the registry lookup section.

## 5. Sysnative can be used to relaunch into 64-bit PowerShell

Using `Sysnative` allowed the script to call the real 64-bit PowerShell executable from a 32-bit process.
