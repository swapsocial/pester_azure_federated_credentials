Describe 'Azure IQ Tests with Pester' {

    # Initialize an array to store test results
    $testResults = @()

    Context 'Check if Resource Group exists' {
        It 'Should verify that the resource group exists' {
            $resourceGroupName = 'YourResourceGroupName'
            $result = az group show --name $resourceGroupName --output json

            $result | Should -Not -BeNullOrEmpty
            $resourceGroup = $result | ConvertFrom-Json
            $resourceGroup.name | Should -BeExactly $resourceGroupName

            # Collect result with debugging message
            $testResults += "Resource group '$resourceGroupName' exists and validated."
            Write-Host "Test passed: Resource group '$resourceGroupName' exists."
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

            # Collect result with debugging message
            $testResults += "Virtual Machine '$vmName' exists in resource group '$resourceGroupName'."
            Write-Host "Test passed: Virtual Machine '$vmName' exists."
        }

        It 'Should verify that the VM is running' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm get-instance-view --name $vmName --resource-group $resourceGroupName --query "instanceView.statuses[1].displayStatus" --output tsv

            $result | Should -BeExactly 'VM running'

            # Collect result with debugging message
            $testResults += "Virtual Machine '$vmName' is in running state."
            Write-Host "Test passed: Virtual Machine '$vmName' is running."
        }

        It 'Should verify the VM size' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "hardwareProfile.vmSize" --output tsv

            $expectedSize = 'Standard_B1s'
            $result | Should -BeExactly $expectedSize

            # Collect result with debugging message
            $testResults += "Virtual Machine '$vmName' has expected size '$expectedSize'."
            Write-Host "Test passed: Virtual Machine '$vmName' has size '$expectedSize'."
        }

        It 'Should verify the OS disk type' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "storageProfile.osDisk.managedDisk.storageAccountType" --output tsv

            $expectedDiskType = 'Premium_LRS'
            $result | Should -BeExactly $expectedDiskType

            # Collect result with debugging message
            $testResults += "OS disk for VM '$vmName' has expected disk type '$expectedDiskType'."
            Write-Host "Test passed: OS disk for VM '$vmName' has type '$expectedDiskType'."
        }
    }

    AfterAll {
        # Print the collected results at the end of all tests
        Write-Host "Test Results:"
        if ($testResults.Count -gt 0) {
            $testResults | ForEach-Object { Write-Host $_ }
        } else {
            Write-Host "No results collected."
        }

        # Clean up or log out if needed
        az logout
    }
}
