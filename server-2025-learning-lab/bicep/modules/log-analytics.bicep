// Log Analytics Workspace module for Windows Server 2025 Learning Lab
// Deploys a Log Analytics workspace for centralized logging and monitoring

param location string
param tags object
param workspaceName string

@description('Number of days to retain logs')
param retentionInDays int = 30

@description('Pricing tier: Free, PerGB2018, PerNode, Premium, Standalone, Standard')
@allowed([
  'Free'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param sku string = 'PerGB2018'

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}

// VM Insights solution
resource vmInsights 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'VMInsights(${logAnalyticsWorkspace.name})'
  location: location
  tags: tags
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: 'VMInsights(${logAnalyticsWorkspace.name})'
    publisher: 'Microsoft'
    product: 'OMSGallery/VMInsights'
    promotionCode: ''
  }
}

// Security solution for enhanced security monitoring
resource securitySolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'Security(${logAnalyticsWorkspace.name})'
  location: location
  tags: tags
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: 'Security(${logAnalyticsWorkspace.name})'
    publisher: 'Microsoft'
    product: 'OMSGallery/Security'
    promotionCode: ''
  }
}

// Outputs
output workspaceId string = logAnalyticsWorkspace.id
output workspaceName string = logAnalyticsWorkspace.name
output workspaceCustomerId string = logAnalyticsWorkspace.properties.customerId 
