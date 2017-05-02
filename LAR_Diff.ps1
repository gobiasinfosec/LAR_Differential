# Retrieve AD Servers and export to CSV and create a diff from baseline

Import-Module ActiveDirectory

# Set filepaths for variables
$Baseline = "c:\temp\workstation_LAR_baseline.csv"
$LarOutput = 'c:\temp\workstation_LAR.csv'
$Diff = "c:\temp\workstation_lar_diff_" + (Get-Date -Format "MM-dd-yyyy") + ".csv."
$ou = "*" # "*" to pull information from all OU's

# Do the lookup and create the output file
echo "AD-Lookup running, do not close window"
$Servers = Get-ADComputer -filter {Enabled -eq $true} | Where-Object{$_.DistinguishedName -like $ou } | Select-Object Name

# Create a new empty array for results
$results = @()

# Loop through each server, first creating an empty array for members, then connecting and pulling the administrators member list
foreach($server in $servers.name)
{
 $members = @()
 $group =[ADSI]"WinNT://$server/Administrators" 
 $members = $group.Members() | foreach {$_.GetType().InvokeMember("Adspath", 'GetProperty', $null, $_, $null) } 

 # Look through each member and write the server and member to the results array
 foreach($member in $members){
 $results += New-Object PsObject -Property @{
  Workstation = $server
  Member = $member -join ","
  }
 }
}

# Write the results array to a csv file
$results | convertto-csv -NoTypeInformation -Delimiter "," | % { $_ -replace '"', ""} | out-file $LarOutput -Encoding ascii

# Reimport output with headers
$Compare = Import-Csv -Path $LarOutput -Header "Workstation", "Member"

# Look for a baseline, if it does not exist, copy output as the baseline
if(!(Test-Path $Baseline)){$Compare | Export-Csv -NoTypeInformation $Baseline}

# Compare to baseline and output differences
$BaseCompare = Import-Csv -Path $Baseline -Header "Worksation", "Member"
Compare-Object $BaseCompare $Compare -Property "Worksation", "Member" -PassThru| Export-Csv $Diff -NoTypeInformation

# Rename the old baseline to baseline.csv.old and the new export to baseline.csv
Copy-Item $Baseline "$Baseline.old"
$Compare | Export-Csv -NoTypeInformation $Baseline

# Replace arrows with more descriptive text in output file
(Get-Content $Diff).replace('<=', 'Removed Permission') | Set-Content $Diff
(Get-Content $Diff).replace('=>', 'New Permission') | Set-Content $Diff

# Remove temp file
if(Test-Path $Output){Remove-Item $Output}

echo "Results can be found in $Diff"
