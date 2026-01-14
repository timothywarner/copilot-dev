# Infrastructure

This directory contains Azure infrastructure as code using Bicep templates.

## Files

- **main.bicep** - Main Bicep template for virtual network deployment
- **deploy.sh** - Deployment script with validation checks

## Overview

The Bicep template creates a virtual network with a properly configured subnet. The deployment script includes validation checks to catch misconfigurations early in the deployment process.

## Prerequisites

- Azure CLI installed and configured
- Azure subscription with appropriate permissions
- Bash shell (Linux, macOS, or WSL on Windows)

## Configuration

The template uses the following default values:

- **Virtual Network Address Space**: `10.0.0.0/16`
- **Subnet Address Prefix**: `10.0.0.0/24`
- **Location**: `eastus` (configurable via environment variable)
- **Resource Group**: `rg-copilot-dev` (configurable via environment variable)

These can be overridden by providing parameters during deployment.

## Deployment

### Basic Deployment

```bash
cd infrastructure
./deploy.sh
```

### Custom Resource Group and Location

```bash
export RESOURCE_GROUP_NAME="my-resource-group"
export LOCATION="westus2"
cd infrastructure
./deploy.sh
```

### Deployment with Custom Parameters

To deploy with custom parameters, modify the Bicep file or use parameter files:

```bash
az deployment group create \
  --name my-deployment \
  --resource-group rg-copilot-dev \
  --template-file main.bicep \
  --parameters vnetAddressPrefix='192.168.0.0/16' subnetAddressPrefix='192.168.1.0/24'
```

## Validation

The deployment script includes several validation checks:

1. **Azure CLI Installation**: Verifies Azure CLI is installed
2. **Azure Login**: Checks if logged in to Azure
3. **Bicep File Existence**: Confirms the Bicep file exists
4. **Bicep Syntax**: Validates Bicep syntax using `az bicep build`
5. **VNet Configuration**: Validates that subnet address prefix is within VNet address space
6. **What-If Deployment**: Runs a what-if deployment to preview changes

## Testing

Unit tests are available in the `/tests` directory:

```bash
pwsh tests/bicep_template_tests.ps1
```

The tests validate:
- Bicep file structure and syntax
- Required parameters and outputs
- Virtual network and subnet configuration
- Address space alignment

## Outputs

The template provides the following outputs after deployment:

- `vnetId` - Resource ID of the virtual network
- `vnetName` - Name of the virtual network
- `vnetAddressSpace` - Address space of the virtual network
- `subnetId` - Resource ID of the subnet
- `subnetName` - Name of the subnet
- `subnetAddressPrefix` - Address prefix of the subnet

## Troubleshooting

### Deployment Fails with VNet Configuration Error

If you see an error about virtual network configuration:

1. Verify that the subnet address prefix is within the virtual network address space
2. Check the default values in `main.bicep`
3. Ensure no overlapping address spaces if deploying multiple subnets

### Azure CLI Not Found

Install Azure CLI:
- **Windows**: Download from https://aka.ms/installazurecliwindows
- **macOS**: `brew install azure-cli`
- **Linux**: Follow instructions at https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux

### Not Logged In to Azure

Run:
```bash
az login
```

## Security Best Practices

- Never commit Azure credentials to the repository
- Use managed identities when deploying from CI/CD pipelines
- Follow the principle of least privilege for resource group permissions
- Enable network security groups (NSGs) for production deployments

## Future Enhancements

Potential improvements to this infrastructure:

- [ ] Add Network Security Group (NSG) configuration
- [ ] Support for multiple subnets
- [ ] Add virtual network peering configuration
- [ ] Implement Azure Firewall or Application Gateway
- [ ] Add diagnostic settings and monitoring
- [ ] Create parameter files for different environments

## Related Documentation

- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure Virtual Network Documentation](https://docs.microsoft.com/en-us/azure/virtual-network/)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
