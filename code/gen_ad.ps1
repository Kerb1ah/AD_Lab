param([parameter(Mandatory=$true)]$JSONFile)


function CreateADGroup {
    param ([Parameter(Mandatory=$True)] $groupObject)

    $name =$groupObject.name
    New-ADGroup -name $name -GroupScope Global
    
}

function CreateADUser(){
    param( [Parameter(Mandatory=$True)] $UserObject )

    #Pull out the name from the JSON object
    $name = $userObject.name
    $password = $userObject.password

    #Generate a first inital last name structure for username
    $firstname, $lastname=$name.split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    $principalname = $username


    #actually create AD user Onject
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount 

    #Add users to appropriate group
    foreach($group_name in $userObject.groups) {

        try {

            Get-ADGroup -Identity "$group"
            Add-ADGroupMemeber -Idenity $group -Members $username
        }

        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $name NOT added to group $Group_name becasue it does not exist"
        }
        
    }
}

$json =  (Get-Content $JSONFile | ConvertFrom-Json)

$Global:Domain = $json.domain

foreach ($group in $json.groups){
    CreateADGroup $group
}


foreach ($user in $json.users){
    CreateADUser $user
}
    