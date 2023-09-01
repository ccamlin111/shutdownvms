# Shutdown script for VMware vms
This script will shut down all VMs on a VMware Cluster or a standalone ESXi Host.  This script will work on any VCSA or ESXI host. 
If $pattern1 and #pattern2 are not found within the VM's names, then all VMs are included. You can adjust this script to act upon
a small number of vm's for testing.

Prerequisites
1.	PowerShell 7
2.	PowerCLI   https://developer.vmware.com/web/tool/vmware-powercli
