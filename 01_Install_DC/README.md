# Domain Controller Set up

1. Use SConfig to:
    - change hostname - DC01
    - Change the IP address to static - 192.168.204.254 (IP can be differdent on each install)
    - Change DNS server to own IP Address - 192.168.204.254
    
     **You will need to add this to your trusted hosts on the management PC if you are configuring DC from there**
     
    ```shell 
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value <YOUR NEW IP>
    ```


2. Install the Active Directory WIndows Feature: Full guide https://xpertstec.com/how-to-install-active-directory-windows-server-core-2022/?utm_content=cmp-true

```Shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

# Installing Domain Services
```Shell
import-Module ADDSDeployment
```
```shell
install-ADDSForest
```
```Shell
Set Domain to XYZ.Local
```

Use Sconfig to reconfigure our DNS server IP to our own IP 192.168.204.253


