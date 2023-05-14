param([parameter(Mandatory=$true)]$JSONFile)


function CreateADGroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )

    $name = $groupObject.name
    echo $name
    New-ADGroup -name $name -GroupScope Global
    
}
#function RemoveADGroup {
    #param ([Parameter(Mandatory=$True)] $groupObject)

    #$name =$groupObject.name
    #Remove-ADGroup -Identity $name -Confirm:$False
    
#}
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


    #actually create AD user Object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount 

    #Add users to appropriate group
    foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }

        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning "User $name NOT added to group $Group_name becasue it does not exist"
        }
    }
}

function WeakenPasswordPolicy(){
    secedit /export /cfg c:\Windows\Tasks\secpol.cfg
(Get-Content c:\Windows\Tasks\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
remove-item -force c:\secpol.cfg -confirm:$false
}

WeakenPasswordPolicy


$json = (Get-Content $JSONFile | ConvertFrom-Json)

$Global:Domain = $json.domain

foreach ( $group in $json.groups ){
    CreateADGroup $group
}

$json = (Get-Content $JSONFile | ConvertFrom-Json)





#foreach ($user in $json.users){
 #   CreateADUser $user
#}