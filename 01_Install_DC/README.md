# Domain Controller Set up

1. use SCConfig to:
    - change hostname
    -Change the IP address to static
    Change DNS server to own IP Address

2. Imnstall the Active Directory WIndows Feature

```Shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```


