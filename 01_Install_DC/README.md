# Domain Controller Set up

1. use SCConfig to:
    - change hostname - DC01
    -Change the IP address to static - 192.168.204.254 (IP can be differdent on each install)
    Change DNS server to own IP Address - 192.168.204.254

2. Imnstall the Active Directory WIndows Feature: Full guide https://xpertstec.com/how-to-install-active-directory-windows-server-core-2022/?utm_content=cmp-true

```Shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```


