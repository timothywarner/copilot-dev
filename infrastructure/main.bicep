// Parameters
@description('Location for all resources')
param location string = resourceGroup().location

@description('Name of the virtual network')
param vnetName string = 'myVNet'

@description('Address space for the virtual network')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Name of the subnet')
param subnetName string = 'mySubnet'

@description('Address prefix for the subnet - must be within the virtual network address space')
param subnetAddressPrefix string = '10.0.0.0/24'

@description('Tags to apply to resources')
param tags object = {
  environment: 'development'
  project: 'copilot-dev'
}

// Virtual Network Resource
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

// Outputs
@description('The resource ID of the virtual network')
output vnetId string = virtualNetwork.id

@description('The name of the virtual network')
output vnetName string = virtualNetwork.name

@description('The address space of the virtual network')
output vnetAddressSpace string = vnetAddressPrefix

@description('The subnet resource ID')
output subnetId string = virtualNetwork.properties.subnets[0].id

@description('The subnet name')
output subnetName string = subnetName

@description('The subnet address prefix')
output subnetAddressPrefix string = subnetAddressPrefix
