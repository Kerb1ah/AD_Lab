param([parameter(mandatory=$True)] $OutputJSONFile)

$group_names =[system.collections.ArrayList](get-content "data/group_names.txt")
$First_names =[system.collections.ArrayList](get-content "data/First_names.txt")
$Last_names =[system.collections.ArrayList](get-content "data/Last_names.txt")
$passwords =[system.collections.ArrayList](get-content "data/passwords.txt")


$groups = @()
$users = @()

$num_groups = 10
for ($i = 0; $i -lt $num_groups; $i++ ){
    $new_group = (get-random -inputObject $group_names)
    $groups += @{"name" = $new_group }
    $group_names.Remove($group_name)
}

$users = @()
$num_users = 100
for ($i = 0; $i -lt $num_users; $i++ ){
    $first_name = (get-random -inputObject $First_names)
    $last_name = (get-random -inputObject $Last_names)
    $password = (get-random -inputObject $passwords)
    $new_user = @{
        "name"="$first_name $last_name"
        "password"="$password"
        "groups" = @((get-random -inputObject $groups).name)
        }
    $users += $new_user
    $first_names.Remove($first_name)
    $last_names.Remove($last_name)
    $passwords.Remove($password)
}

echo @{"domain"="xyz.local"
#"groups"=$groups
"users" = $users} | ConvertTo-Json | Out-File $OutputJSONFile