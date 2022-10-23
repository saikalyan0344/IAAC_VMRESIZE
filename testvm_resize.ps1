$AzVMs = Get-AzureRmVM | Select-Object -Property Name, ResourceGroupName, Location, Type, ProvisioningState

$VMsList = @("TestVM", "TestVM2", "TestVM3") #Provide your VM List that need to be Resized
$NewAzureSize = "Standard_B2s" #Provide your New Azure VM Size

foreach ($VM in $AzVMs)
{
   $VMName = $VM.Name
   $ResourceGroupName = $VM.ResourceGroupName
   $Type = $VM.Type
   $Location = $VM.Location
   $ProvisioningState = $VM.ProvisioningState

    if ($VMsList -contains $VMName)
    {
        Write-Host "--------------------------------------------------------------------"
        Write-Host "Virtual Machine: $VMName"
        Write-Host "ResourceGroup  : $ResourceGroupName"
        Write-Host "Location   : $Location"
        Write-Host "ResourceType   : $Type"
        Write-Host "ProvisioningState   : $ProvisioningState"    
        Write-Host "--------------------------------------------------------------------"
        Write-Host "Deallocating $VMName VM."
        Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force
        Write-Host "$VMName VM Stopped."
        Write-Host "--------------------------------------------------------------------"
        Write-Host "Updating $VMName VMSize."
        $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -VMName $VMName
        $vm.HardwareProfile.VmSize = $AzureSize
        Update-AzVM -VM $vm -ResourceGroupName $ResourceGroupName
        Write-Host "Successfully resized $VMName VM to size $NewAzureSize."
        Write-Host "--------------------------------------------------------------------"
        Write-Host "Starting $VMName VM"
        Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
        Write-Host "$VMName VM Started."
        Write-Host "--------------------------------------------------------------------"
    }
}  
