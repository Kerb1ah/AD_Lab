# Configure DNS Settings on host

1. You will need to match the IP address of the DC for your workstations DNS settings
2. Get-DnsClientServerAddress <use this to pick your interface> In my case it is 5
3. Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses 192.168.204.253


# Add device to domain

1. Using Pshell ```shell 
add-computer –domainname xyz.local -Credential (Get-credential) -restart –force
 ```