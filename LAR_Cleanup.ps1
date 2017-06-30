#give this script a 2 column CSV first the first column being computers, the second being users
$comp_list = Import-Csv "" -Header Computer, User

#remove noise from errors
$ErrorActionPreference = "SilentlyContinue"
$csv_line = 0

#this will pull each pair, connect to the computer, then remove the user specified and the line it's on in the csv
foreach ($pair in $comp_list) {
    $computer = $pair.Computer
    $user = $pair.User
    $group = ''
    $csv_line += 1

    $group =[ADSI]"WinNT://$computer/Administrators"
    try {
        $group.Remove($user)
        echo "$csv_line : Removed $user from $computer"
        }
    catch {
        echo "Unable to remove $user from $computer"
        }
    } 
