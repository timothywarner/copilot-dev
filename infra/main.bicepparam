// =============================================================================
// Parameter file — dev environment defaults
// Copy to main.prod.bicepparam and adjust for production.
// =============================================================================

using './main.bicep'

param appName          = 'copilottips'
param location         = 'eastus'
param appServiceSkuName = 'B1'          // cheapest tier for demos
param nodeVersion      = 'NODE|20-lts'
param environment      = 'dev'
