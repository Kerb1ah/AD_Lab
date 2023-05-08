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
    $firstname, $lastname =$name.split(" ")
    $password = $userobject.password

    #Generate a first inital last name structure for username
    $username = ($firstname[0] + $lastname.ToLower)
    $samAccountName = $username
    $prinicipalname = $username


    #actually create AD user Onject
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $generated_password -AsPlainText -Force) -PassThru | Enable-ADAccount 

    #Add users to appropriate group
    foreach($group in $userObject.groups) {
        Add-ADGroupMemeber -Idenity $group -Members $username
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
    