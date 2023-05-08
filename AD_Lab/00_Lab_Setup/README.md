# 00 - Install VMs

*Installed Windows Server 2022 VM in VMware Workstation Pro/n
*Installed Windows 11 VM VMware Workstation Pro
    -Configured Windows 11 Machine for no TPM Check - https://www.tomshardware.com/how-to/bypass-windows-11-tpm-requirement
-Installed VMware Tools on both machines
-Set both machines to template mode
-Create Snapshot of both machines
-Created new machines and named appropriately

Create PS Session to server from Management Host

```
New-PSSession -Computername 192.168.204.253 -Credential (Get-credential)
```
