// Domain Controllers module for Windows Server 2025 Learning Lab
// Deploys two DC VMs and configures AD DS

param location string
param tags object
param prefix string

param adminUsername string

@secure()
param adminPassword string

param domainName string
param subnetId string
param keyVaultName string
param deployDC2 bool = true // Parameter to control whether to deploy the second DC
param vmNameDC1 string = 'dc1' // Parameter for primary DC name
param vmNameDC2 string = 'dc2' // Parameter for secondary DC name
param logAnalyticsWorkspaceId string = '' // Parameter for Log Analytics workspace ID

// VM configuration
var resourceNameDC1 = '${prefix}-${vmNameDC1}' // Resource name (can be longer)
var resourceNameDC2 = '${prefix}-${vmNameDC2}' // Resource name (can be longer)
var computerNameDC1 = vmNameDC1 // Computer name must be 15 chars or less
var computerNameDC2 = vmNameDC2 // Computer name must be 15 chars or less
var vmSize = 'Standard_D2s_v3' // 2 vCPUs, 8 GB RAM
var osDiskSizeGB = 128
var imageReference = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2025-datacenter-g2'
  version: 'latest'
}

// NIC configurations
resource dc1Nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${resourceNameDC1}-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.0.4'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    enableIPForwarding: false
    enableAcceleratedNetworking: true
  }
}

resource dc2Nic 'Microsoft.Network/networkInterfaces@2023-05-01' = if (deployDC2) {
  name: '${resourceNameDC2}-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.0.5'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
    enableIPForwarding: false
    enableAcceleratedNetworking: true
  }
}

// DC1 - Primary Domain Controller
resource dc1Vm 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: resourceNameDC1
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        diskSizeGB: osDiskSizeGB
      }
      imageReference: imageReference
    }
    osProfile: {
      computerName: computerNameDC1
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: dc1Nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

// DC2 - Secondary Domain Controller
resource dc2Vm 'Microsoft.Compute/virtualMachines@2023-07-01' = if (deployDC2) {
  name: resourceNameDC2
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        diskSizeGB: osDiskSizeGB
      }
      imageReference: imageReference
    }
    osProfile: {
      computerName: computerNameDC2
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: dc2Nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

// Install AD DS on DC1 and create forest
resource dc1ConfigADDS 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: dc1Vm
  name: 'InstallADDS'
  location: location
  tags: tags
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools; Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath \'C:\\Windows\\NTDS\' -DomainMode \'WinThreshold\' -DomainName \'${domainName}\' -ForestMode \'WinThreshold\' -InstallDns:$true -LogPath \'C:\\Windows\\NTDS\' -NoRebootOnCompletion:$false -SysvolPath \'C:\\Windows\\SYSVOL\' -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString \'${adminPassword}\' -AsPlainText -Force)"'
    }
  }
}

// Set Static DNS on DC2 and promote to domain controller
resource dc2ConfigADDS 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = if (deployDC2) {
  parent: dc2Vm
  name: 'InstallADDS'
  location: location
  tags: tags
  dependsOn: [
    dc1ConfigADDS
  ]
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools; $securePassword = ConvertTo-SecureString \'${adminPassword}\' -AsPlainText -Force; $credential = New-Object System.Management.Automation.PSCredential(\'${domainName}\\${adminUsername}\', $securePassword); Install-ADDSDomainController -Credential $credential -DomainName \'${domainName}\' -InstallDns:$true -DatabasePath \'C:\\Windows\\NTDS\' -LogPath \'C:\\Windows\\NTDS\' -SysvolPath \'C:\\Windows\\SYSVOL\' -NoRebootOnCompletion:$false -Force:$true -SafeModeAdministratorPassword $securePassword"'
    }
  }
}

// Store secrets in Key Vault
resource keyVaultUpdate 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: '${keyVaultName}/vm-admin-password'
  properties: {
    value: adminPassword
  }
  dependsOn: deployDC2 ? [
    dc1ConfigADDS
    dc2ConfigADDS
  ] : [
    dc1ConfigADDS
  ]
}

// Install additional tools and setup demo environment
resource dc1ConfigTools 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: dc1Vm
  name: 'ConfigureTools'
  location: location
  tags: tags
  dependsOn: deployDC2 ? [
    dc1ConfigADDS
    dc2ConfigADDS
  ] : [
    dc1ConfigADDS
  ]
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "Install-WindowsFeature -Name RSAT-AD-Tools, RSAT-DNS-Server"'
    }
  }
}

// Remove the ADCS install on DC1 since we'll do it on the member server
resource dc1ConfigADCS 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: dc1Vm
  name: 'InstallADCS'
  location: location
  tags: tags
  dependsOn: [
    dc1ConfigTools
  ]
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "New-Item -Path C:\\ADCS -ItemType Directory -Force"'
    }
  }
}

// Log Analytics agent for DC1
resource dc1LogAnalytics 'Microsoft.Compute/virtualMachines/extensions@2023-07-01' = if (!empty(logAnalyticsWorkspaceId)) {
  parent: dc1Vm
  name: 'MicrosoftMonitoringAgent'
  location: location
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: 'MicrosoftMonitoringAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    settings: {
      workspaceId: !empty(logAnalyticsWorkspaceId) ? reference(logAnalyticsWorkspaceId, '2022-10-01').customerId : ''
    }
    protectedSettings: {
      workspaceKey: !empty(logAnalyticsWorkspaceId) ? listKeys(logAnalyticsWorkspaceId, '2022-10-01').primarySharedKey : ''
    }
  }
}

// Log Analytics agent for DC2
resource dc2LogAnalytics 'Microsoft.Compute/virtualMachines/extensions@2023-07-01' = if (deployDC2 && !empty(logAnalyticsWorkspaceId)) {
  parent: dc2Vm
  name: 'MicrosoftMonitoringAgent'
  location: location
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: 'MicrosoftMonitoringAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    settings: {
      workspaceId: !empty(logAnalyticsWorkspaceId) ? reference(logAnalyticsWorkspaceId, '2022-10-01').customerId : ''
    }
    protectedSettings: {
      workspaceKey: !empty(logAnalyticsWorkspaceId) ? listKeys(logAnalyticsWorkspaceId, '2022-10-01').primarySharedKey : ''
    }
  }
}

// Outputs
output dc1Name string = resourceNameDC1
output dc1PrivateIp string = dc1Nic.properties.ipConfigurations[0].properties.privateIPAddress
output dc2Name string = deployDC2 ? resourceNameDC2 : 'NotDeployed'
output dc2PrivateIp string = deployDC2 ? dc2Nic.properties.ipConfigurations[0].properties.privateIPAddress : '' 


