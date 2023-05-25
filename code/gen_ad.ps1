param(
    [parameter(Mandatory=$true)]$JSONFile,
    [switch]$Undo
    )


function CreateADGroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )

    $name = $groupObject.name
    echo $name
    New-ADGroup -name $name -GroupScope Global
    
}

function RemoveADGroup {
    param ([Parameter(Mandatory=$True)] $groupObject)

    $name =$groupObject.name
    Remove-ADGroup -Identity $name -Confirm:$False
    
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

function RemoveADUser {
    param ([Parameter(Mandatory=$True)] $userObject)

    $name =$userObject.name
    $firstname, $lastname=$name.split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    Remove-ADUser -Identity $samAccountName -Confirm:$False
    
}

function WeakenPasswordPolicy(){
    secedit /export /cfg c:\Windows\Tasks\secpol.cfg
(Get-Content c:\Windows\Tasks\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0").replace("MinimumpasswordLength = 7", "MinimumpasswordLength = 1") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
remove-item -force c:\secpol.cfg -confirm:$false
}

function StrengthenPasswordPolicy(){
    secedit /export /cfg c:\Windows\Tasks\secpol.cfg
(Get-Content c:\Windows\Tasks\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0").replace("MinimumpasswordLength = 1", "MinimumpasswordLength = 7") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
remove-item -force c:\secpol.cfg -confirm:$false
}

$json = (Get-Content $JSONFile | ConvertFrom-Json)
$Global:Domain = $json.domain

if(-not $undo) {
    WeakenPasswordPolicy
    foreach ( $group in $json.groups ){
        CreateADGroup $group
    }

$json = (Get-Content $JSONFile | ConvertFrom-Json)

foreach ($user in $json.users){
        CreateADUser $user
    }
}else{

    StrengthenPasswordPolicy
    foreach ( $group in $json.groups ){
        RemoveADGroup $group
    }

$json = (Get-Content $JSONFile | ConvertFrom-Json)

    foreach ($user in $json.users){
        RemoveADUser $user

    }
}




