# Chet Camlin Aug 2023
# This script will work on any VCSA or ESXI host. If $pattern1 and #pattern2 are not found
# within the VM's names, then all VM's are included. You can adjust this script to act upon a small number of vm's for testing.   


#This must be run atleast once so the self-signed certs do not prevent the connection.
#STEP 1
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

#Connection String for the vCenter being controlled.
#STEP 2
Connect-VIServer -Server 192.168.1.1 -User 'vine' -Password 'mysecretpass'

#Pattern to look for Critical servers.
#STEP 3
$pattern1 = "CR-*"
$pattern2 = "*CVM*"

# Retrieve all VMs running or not then Exclude VMs based on the
# pattern(s) by using the argument -notlilke . The last variable (filteredVMs2) will
# hold all VMs not matching the patterns and be displayed to the screen. 
$VMs = Get-VM
$filteredVMs1 = $VMs | Where-Object { $_.Name -notlike $pattern1 }
$filteredVMs2 = $filteredVMs1 | Where-Object { $_.Name -notlike $pattern2 }

#STEP 4
Write-Host "Virtual Machine Name(s) are: $filteredVMs2" -ForegroundColor Magenta

# Iterate over each VM in $filteredVMs2 and perform actions
foreach ($VM in $filteredVMs2) {

    # Check if the VM is powered off
    if ($VM.PowerState -eq "PoweredOff") {
     
        #Add "Write-Host" for results"
        Write-Host "Skipping tools check for VM: $($VM.Name) because it is powered off."
        continue  # Skip to the next iteration
    }

    # Check VMware Tools status
    $toolsStatus = $vm.ExtensionData.Guest.ToolsStatus
    
    if ($toolsStatus -eq "toolsOk" -or $toolsStatus -eq "toolsOld") {
        Write-Host "VMware Tools are installed." -ForegroundColor Red
        #Smooth shutdown
        Shutdown-VMGuest -VM $VM -Confirm:$false
    } else {
        Write-Host "VMware Tools are not installed." -ForegroundColor Red
        #Terminate 
        Stop-VM -VM $VM -Confirm:$false
    }
}

# Disconnect from vCenter Server. input the ip address of the VCSA.  Do not include the // // forward slashes. 
Disconnect-VIServer -Server 192.168.1.1 -Confirm:$false



