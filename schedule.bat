:: Use this batch script to launch the powershell script as admin and prompt for credentials (useful for running from a non-admin account as a scheduled task)
:: Task Scheduler -> Create Basic Task -> Action 'Start a program' -> 'c:\temp\scripts\schedule.bat'

powershell -noprofile -command "&{ start-process powershell -ArgumentList '-noprofile -file C:\temp\scripts\LAR_Diff.ps1' -verb RunAs}"
