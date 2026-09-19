// =============================================================================
// GitHub Copilot Tips App — Azure App Service Deployment
// Target: Linux Node.js 20 LTS on Azure App Service
// WAF pillars: Security | Reliability | Cost | Operational Excellence
// =============================================================================

@description('Base name for all resources. Lowercase alphanumeric, 3–20 chars.')
@minLength(3)
@maxLength(20)
param appName string = 'copilottips'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('App Service SKU. B1 for dev/demo; P1v3 for production.')
@allowed(['B1', 'B2', 'P0v3', 'P1v3', 'P2v3'])
param appServiceSkuName string = 'B1'

@description('Node.js runtime version.')
param nodeVersion string = 'NODE|20-lts'

@description('Environment tag (dev, staging, prod).')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

// ---------------------------------------------------------------------------
// Variables
// ---------------------------------------------------------------------------

var uniqueSuffix = uniqueString(resourceGroup().id, appName)
var planName     = 'plan-${appName}-${environment}'
var webAppName   = 'app-${appName}-${environment}-${uniqueSuffix}'
var lawName      = 'law-${appName}-${environment}'
var appInsName   = 'appi-${appName}-${environment}'

var commonTags = {
  application: appName
  environment: environment
  managedBy:   'bicep'
  costCenter:  'demo'
}

// ---------------------------------------------------------------------------
// Log Analytics Workspace  (backing store for App Insights)
// ---------------------------------------------------------------------------

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name:     lawName
  location: location
  tags:     commonTags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// ---------------------------------------------------------------------------
// Application Insights
// ---------------------------------------------------------------------------

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name:     appInsName
  location: location
  kind:     'web'
  tags:     commonTags
  properties: {
    Application_Type:                'web'
    WorkspaceResourceId:             logAnalyticsWorkspace.id
    IngestionMode:                   'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery:     'Enabled'
  }
}

// ---------------------------------------------------------------------------
// App Service Plan  (Linux)
// ---------------------------------------------------------------------------

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name:     planName
  location: location
  tags:     commonTags
  kind:     'linux'
  sku: {
    name: appServiceSkuName
  }
  properties: {
    reserved: true  // required for Linux
  }
}

// ---------------------------------------------------------------------------
// App Service (Web App)
// ---------------------------------------------------------------------------

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name:     webAppName
  location: location
  tags:     commonTags
  kind:     'app,linux'
  identity: {
    type: 'SystemAssigned'  // enables managed identity for future Key Vault use
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly:    true           // Security: enforce HTTPS
    siteConfig: {
      linuxFxVersion:         nodeVersion
      nodeVersion:            nodeVersion
      alwaysOn:               appServiceSkuName != 'B1'  // B1 doesn't support AlwaysOn
      ftpsState:              'Disabled'                  // Security: disable FTP
      http20Enabled:          true
      minTlsVersion:          '1.2'
      scmMinTlsVersion:       '1.2'
      healthCheckPath:        '/api/tips'                 // liveness probe
      appCommandLine:         'node server.js'
      appSettings: [
        {
          name:  'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name:  'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name:  'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name:  'NODE_ENV'
          value: environment == 'prod' ? 'production' : 'development'
        }
        {
          name:  'PORT'
          value: '8080'
        }
        {
          name:  'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~20'
        }
      ]
    }
  }
}

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------

@description('The public URL of the deployed web app.')
output appUrl string = 'https://${webApp.properties.defaultHostName}'

@description('The resource name of the web app (needed for az webapp deploy).')
output webAppName string = webApp.name

@description('The resource group the app was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('Application Insights connection string.')
output appInsightsConnectionString string = appInsights.properties.ConnectionString

@description('Managed Identity principal ID (for RBAC assignments).')
output principalId string = webApp.identity.principalId
