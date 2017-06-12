# LAR Differential

This tool is designed to pull a list of machines from AD and then enumerate their LAR permissions. This should be run with either a DOMAIN or WORKSTATION Admin account.

After it runs, the full output can be found at your $Baseline variable location, any changes will be found in the csv at your $Diff file location.

###Instructions

Edit the variables on lines 5-9 of the script per your needs. 

This can then be set to run on a regular basis using task scheduler or some other means. As it is not recommended to keep an account logged in at all times, I have this setup to run a batch file that will prompt for admin credentials so that part is still done manually.
