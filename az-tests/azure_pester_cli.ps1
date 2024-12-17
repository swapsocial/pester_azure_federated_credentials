Describe 'Azure IQ Tests with Pester' {

    $testResults = @()

    Context 'Check if Resource Group exists' {
        It 'Should verify that the resource group exists' {
            $resourceGroupName = 'YourResourceGroupName'
            $result = az group show --name $resourceGroupName --output json

            $result | Should -Not -BeNullOrEmpty
            $resourceGroup = $result | ConvertFrom-Json
            $resourceGroup.name | Should -BeExactly $resourceGroupName

            # Collect result
            $testResults += "Resource group '$resourceGroupName' exists and validated."
        }

    }

    Context 'Check if a Virtual Machine exists' {

        It 'Should verify that the VM exists in the resource group' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'
            
            $result = az vm show --name $vmName --resource-group $resourceGroupName --output json

            $result | Should -Not -BeNullOrEmpty
            $vm = $result | ConvertFrom-Json
            $vm.name | Should -BeExactly $vmName

            # Collect result
            $testResults += "Virtual Machine '$vmName' exists in resource group '$resourceGroupName'."
        }

        It 'Should verify that the VM is running' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm get-instance-view --name $vmName --resource-group $resourceGroupName --query "instanceView.statuses[1].displayStatus" --output tsv

            $result | Should -BeExactly 'VM running'

            # Collect result
            $testResults += "Virtual Machine '$vmName' is in running state."
        }

        It 'Should verify the VM size' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "hardwareProfile.vmSize" --output tsv

            $expectedSize = 'Standard_B1s'
            $result | Should -BeExactly $expectedSize

            # Collect result
            $testResults += "Virtual Machine '$vmName' has expected size '$expectedSize'."
        }

        It 'Should verify the OS disk type' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "storageProfile.osDisk.managedDisk.storageAccountType" --output tsv

            $expectedDiskType = 'Premium_LRS'
            $result | Should -BeExactly $expectedDiskType

            # Collect result
            $testResults += "OS disk for VM '$vmName' has expected disk type '$expectedDiskType'."
        }
    }

    AfterAll {
        # Print the collected results at the end of all tests
        Write-Host "Test Results:"
        $testResults | ForEach-Object { Write-Host $_ }

        # Clean up or log out if needed
        az logout
    }
}
