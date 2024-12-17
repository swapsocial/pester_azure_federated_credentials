Describe 'Azure IQ Tests with Pester' {

    # Initialize an array to store test results
    $testResults = @()

    Context 'Check if Resource Group exists' {
        It 'Should verify that the resource group exists' {
            $resourceGroupName = 'YourResourceGroupName'
            $result = az group show --name $resourceGroupName --output json

            if ($result) {
                $resourceGroup = $result | ConvertFrom-Json
                $resourceGroup.name | Should -BeExactly $resourceGroupName
                $testResults += "Resource group '$resourceGroupName' exists and validated."
                Write-Host "Test passed: Resource group '$resourceGroupName' exists."
            } else {
                $testResults += "Error: Resource group '$resourceGroupName' does not exist."
                Write-Host "Error: Resource group '$resourceGroupName' does not exist."
            }
        }
    }

    Context 'Check if a Virtual Machine exists' {

        It 'Should verify that the VM exists in the resource group' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'
            
            $result = az vm show --name $vmName --resource-group $resourceGroupName --output json

            if ($result) {
                $vm = $result | ConvertFrom-Json
                $vm.name | Should -BeExactly $vmName
                $testResults += "Virtual Machine '$vmName' exists in resource group '$resourceGroupName'."
                Write-Host "Test passed: Virtual Machine '$vmName' exists."
            } else {
                $testResults += "Error: Virtual Machine '$vmName' does not exist."
                Write-Host "Error: Virtual Machine '$vmName' does not exist."
            }
        }

        It 'Should verify that the VM is running' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            try {
                $result = az vm get-instance-view --name $vmName --resource-group $resourceGroupName --query "instanceView.statuses[1].displayStatus" --output tsv

                if ($result -eq 'VM running') {
                    $testResults += "Virtual Machine '$vmName' is running."
                    Write-Host "Test passed: Virtual Machine '$vmName' is running."
                } else {
                    $testResults += "Error: Virtual Machine '$vmName' is not running. Status: $result."
                    Write-Host "Error: Virtual Machine '$vmName' is not running. Status: $result."
                }
            } catch {
                $testResults += "Error: Failed to check the running status of VM '$vmName'. $_"
                Write-Host "Error: Failed to check the running status of VM '$vmName'. $_"
            }
        }

        It 'Should verify the VM size' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "hardwareProfile.vmSize" --output tsv

            $expectedSize = 'Standard_B1s'
            if ($result -eq $expectedSize) {
                $testResults += "Virtual Machine '$vmName' has expected size '$expectedSize'."
                Write-Host "Test passed: Virtual Machine '$vmName' has size '$expectedSize'."
            } else {
                $testResults += "Error: Virtual Machine '$vmName' has size '$result', expected '$expectedSize'."
                Write-Host "Error: Virtual Machine '$vmName' has size '$result', expected '$expectedSize'."
            }
        }

        It 'Should verify the OS disk type' {
            $resourceGroupName = 'YourResourceGroupName'
            $vmName = 'YourVMName'

            $result = az vm show --name $vmName --resource-group $resourceGroupName --query "storageProfile.osDisk.managedDisk.storageAccountType" --output tsv

            $expectedDiskType = 'Premium_LRS'
            if ($result -eq $expectedDiskType) {
                $testResults += "OS disk for VM '$vmName' has expected disk type '$expectedDiskType'."
                Write-Host "Test passed: OS disk for VM '$vmName' has type '$expectedDiskType'."
            } else {
                $testResults += "Error: OS disk for VM '$vmName' has disk type '$result', expected '$expectedDiskType'."
                Write-Host "Error: OS disk for VM '$vmName' has disk type '$result', expected '$expectedDiskType'."
            }
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
