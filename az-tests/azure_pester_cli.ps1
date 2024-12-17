Describe 'Azure IQ Tests with Pester' {

    Context 'Check if Resource Group exists' {

        It 'Should verify that the resource group exists' {
            # Run Azure CLI to check if the resource group exists
            $resourceGroupName = 'YourResourceGroupName'
            $result = az group show --name $resourceGroupName --output json

            # Assert that the resource group exists (it should not be null)
            $result | Should -Not -BeNullOrEmpty

            # Optionally, assert specific properties of the resource group
            $resourceGroup = $result | ConvertFrom-Json
            $resourceGroup.name | Should -BeExactly $resourceGroupName
        }

    }

    Context 'Check if a Virtual Machine exists' {

        It 'Should verify that the VM exists in the resource group' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'
            
            # Run Azure CLI to check if the VM exists
            $result = az vm show --name $vmName --resource-group $resourceGroupName --output json

            # Assert that the VM exists (it should not be null)
            $result | Should -Not -BeNullOrEmpty

            # Optionally, assert specific properties of the VM
            $vm = $result | ConvertFrom-Json
            $vm.name | Should -BeExactly $vmName
        }

        It 'Should verify that the VM is running' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            # Run Azure CLI to check the power state of the VM
            $result = az vm get-instance-view --name $vmName --resource-group $resourceGroupName --query "instanceView.statuses[1].displayStatus" --output tsv

            # Assert that the VM is in a running state
            $result | Should -BeExactly 'VM running'
        }

        It 'Should verify the VM size' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            # Run Azure CLI to check the size of the VM
            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "hardwareProfile.vmSize" --output tsv

            # Assert that the VM is of the expected size
            $expectedSize = 'Standard_B1s'  # Adjust as needed
            $result | Should -BeExactly $expectedSize
        }

        It 'Should verify the OS disk type' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            # Run Azure CLI to check the OS disk type
            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "storageProfile.osDisk.managedDisk.storageAccountType" --output tsv

            # Assert that the OS disk is of the expected type
            $expectedDiskType = 'Premium_LRS'  # Adjust as needed
            $result | Should -BeExactly $expectedDiskType
        }
    }

    AfterAll {
        # Clean up or log out if needed
        az logout
    }
}
