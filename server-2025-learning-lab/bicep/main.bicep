// Windows Server 2025 Learning Lab
// Main deployment file

targetScope = 'subscription'

// Parameters
@description('The Azure region for deploying resources')
param location string = deployment().location

@description('The name of the resource group to deploy into')
param resourceGroupName string = ''

@description('Optional domain name for the Active Directory domain')
@minLength(2)
@maxLength(15)
param domainName string = 'winlab2025'

@description('Tags to apply to all resources')
param tags object = {
  Project: 'WinServer2025Lab'
  Environment: 'Lab'
  ProvisionedBy: 'Bicep'
}

@description('Admin username for all VMs')
param adminUsername string

@description('Admin password for all VMs')
@secure()
param adminPassword string

@description('Deploy secondary domain controller')
param deployDC2 bool = false

@description('Deploy Log Analytics workspace for monitoring and logging')
param deployLogAnalytics bool = true

// Variables
var rgName = !empty(resourceGroupName) ? resourceGroupName : 'rg-winserver2025-${uniqueString(subscription().id)}'
var prefix = 'ws2025'
var logAnalyticsName = '${prefix}-loganalytics'

// Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: tags
}

// Networking module
module networking 'modules/networking.bicep' = {
  name: 'networkingDeployment'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    prefix: prefix
  }
}

// Key Vault module
module keyVault 'modules/keyvault.bicep' = {
  name: 'keyVaultDeployment'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    prefix: prefix
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

// Log Analytics workspace for monitoring and logging
module logAnalytics 'modules/log-analytics.bicep' = if (deployLogAnalytics) {
  name: 'logAnalyticsDeployment'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    workspaceName: logAnalyticsName
  }
}

// Domain Controller (only DC1)
module domainControllers 'modules/domain-controllers.bicep' = {
  name: 'dcDeployment'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    prefix: prefix
    adminUsername: adminUsername
    adminPassword: adminPassword
    domainName: domainName
    subnetId: networking.outputs.adSubnetId
    keyVaultName: keyVault.outputs.keyVaultName
    deployDC2: deployDC2
    vmNameDC1: 'dc1'
    vmNameDC2: 'dc2'
    logAnalyticsWorkspaceId: deployLogAnalytics ? logAnalytics.outputs.workspaceId : ''
  }
}

// Member Server (will be our ADCS server)
module memberServer 'modules/member-server.bicep' = {
  name: 'memberServerDeployment'
  scope: resourceGroup
  dependsOn: [
    domainControllers
  ]
  params: {
    location: location
    tags: tags
    prefix: prefix
    adminUsername: adminUsername
    adminPassword: adminPassword
    domainName: domainName
    subnetId: networking.outputs.serverSubnetId
    dcIpAddress: domainControllers.outputs.dc1PrivateIp
    keyVaultName: keyVault.outputs.keyVaultName
    vmName: 'mem1'
    logAnalyticsWorkspaceId: deployLogAnalytics ? logAnalytics.outputs.workspaceId : ''
  }
}

// Outputs
output resourceGroupName string = resourceGroup.name
output keyVaultName string = keyVault.outputs.keyVaultName
output domain string = domainName
output dc1Name string = domainControllers.outputs.dc1Name
output dc2Name string = domainControllers.outputs.dc2Name
output memberServerName string = memberServer.outputs.memberServerName
output logAnalyticsName string = deployLogAnalytics ? logAnalytics.outputs.workspaceName : 'NotDeployed'
output deploymentInstructions string = 'Use Azure Bastion to connect to VMs. Credentials are stored in Key Vault ${keyVault.outputs.keyVaultName}' 
