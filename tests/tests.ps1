Describe "Check if Resource Group exists" {

    $resourceGroupName = "myResourceGroup"  # Replace with the name of the resource group you want to check
    
    It "should check if the resource group exists" {
        # Attempt to get the resource group
        $resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
        
        # Assert that the resource group is not $null
        $resourceGroup | Should -NotBeNull
    }

    It "should fail if the resource group does not exist" {
        $resourceGroupName = "nonExistentResourceGroup"  # Replace with a name that does not exist

        # Attempt to get the resource group
        $resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

        # Assert that the resource group is $null, meaning it doesn't exist
        $resourceGroup | Should -BeNull
    }
}
