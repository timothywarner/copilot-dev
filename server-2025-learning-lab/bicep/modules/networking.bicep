// Networking module for Windows Server 2025 Learning Lab
// Creates virtual network, subnets, NSGs, and Bastion with essential CAF practices

param location string
param tags object = {
  workload: 'ws2025-lab'
  environment: 'lab'
}
param prefix string

// Network configuration - simplified but secure addressing
var vnetName = '${prefix}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var adSubnetName = 'snet-ad' // CAF naming: snet prefix for subnet
var adSubnetPrefix = '10.0.0.0/24'
var serverSubnetName = 'snet-server'
var serverSubnetPrefix = '10.0.1.0/24'
var clientSubnetName = 'snet-client'
var clientSubnetPrefix = '10.0.2.0/24'
var bastionSubnetName = 'AzureBastionSubnet'
var bastionSubnetPrefix = '10.0.3.0/26'

// DNS settings for AD integration
var dnsServers = [] // Will be updated post DC deployment via PowerShell

// Create NSG for AD subnet with essential security rules
resource adNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${prefix}-nsg-ad'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'AllowDNS'
        properties: {
          priority: 1100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '53'
        }
      }
      {
        name: 'AllowADWeb'
        properties: {
          priority: 1200
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: ['80', '443']
        }
      }
      {
        name: 'AllowADPorts'
        properties: {
          priority: 1300
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: ['389', '636', '88', '445', '464', '135', '3268', '3269', '49152-65535']
        }
      }
      {
        name: 'AllowSSH'
        properties: {
          priority: 1400
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// Create NSG for Server subnet
resource serverNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${prefix}-server-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'AllowSSH'
        properties: {
          priority: 1100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'AllowHttpHttps'
        properties: {
          priority: 1200
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: ['80', '443']
        }
      }
    ]
  }
}

// Create NSG for Client subnet
resource clientNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${prefix}-client-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'AllowSSH'
        properties: {
          priority: 1100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// Create Virtual Network with subnets and DNS settings
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }
    subnets: [
      {
        name: adSubnetName
        properties: {
          addressPrefix: adSubnetPrefix
          networkSecurityGroup: {
            id: adNsg.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
      {
        name: serverSubnetName
        properties: {
          addressPrefix: serverSubnetPrefix
          networkSecurityGroup: {
            id: serverNsg.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
      {
        name: clientSubnetName
        properties: {
          addressPrefix: clientSubnetPrefix
          networkSecurityGroup: {
            id: clientNsg.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
    ]
  }
}

// Create Bastion Host
resource bastionPip 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: '${prefix}-bastion-pip'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2023-05-01' = {
  name: '${prefix}-bastion'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          publicIPAddress: {
            id: bastionPip.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, bastionSubnetName)
          }
        }
      }
    ]
  }
}

// Outputs
output vnetId string = vnet.id
output vnetName string = vnet.name
output adSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, adSubnetName)
output serverSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, serverSubnetName)
output clientSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, clientSubnetName)
output bastionId string = bastionHost.id
output bastionName string = bastionHost.name 
