# Bicep Template Unit Tests

# Load the required modules
Import-Module Az.Resources

# Define the path to the Bicep template
$templatePath = "server-2025-learning-lab/bicep/main.bicep"

# Function to validate the Bicep template
function Test-BicepTemplate {
    param (
        [string]$TemplatePath
    )

    # Compile the Bicep template
    $compiledTemplate = az bicep build --file $TemplatePath --outFile "$TemplatePath.json"

    # Load the compiled template
    $template = Get-Content -Path "$TemplatePath.json" -Raw | ConvertFrom-Json

    # Validate the subnet address prefix
    $vnetAddressSpace = $template.resources | Where-Object { $_.type -eq 'Microsoft.Network/virtualNetworks' } | Select-Object -ExpandProperty properties | Select-Object -ExpandProperty addressSpace | Select-Object -ExpandProperty addressPrefixes
    $subnetAddressPrefix = $template.resources | Where-Object { $_.type -eq 'Microsoft.Network/virtualNetworks/subnets' } | Select-Object -ExpandProperty properties | Select-Object -ExpandProperty addressPrefix

    if ($subnetAddressPrefix -notin $vnetAddressSpace) {
        throw "Subnet address prefix $subnetAddressPrefix is not within the VNet address space $vnetAddressSpace"
    }

    Write-Output "Bicep template validation passed."
}

# Run the test
try {
    Test-BicepTemplate -TemplatePath $templatePath
    Write-Output "Bicep template unit test passed."
} catch {
    Write-Error "Bicep template unit test failed: $_"
}
