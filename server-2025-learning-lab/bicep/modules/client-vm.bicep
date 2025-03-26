// Client VM module for Windows Server 2025 Learning Lab
// Deploys a Windows 11 client VM joined to the domain

param location string
param tags object
param prefix string

param adminUsername string

@secure()
param adminPassword string

param domainName string
param subnetId string
param dcIpAddress string
param keyVaultName string
param vmName string = 'cli1' // Parameter for client VM name

// VM configuration
var resourceName = '${prefix}-${vmName}' // Resource name (can be longer)
var computerName = vmName // Computer name must be 15 chars or less
var vmSize = 'Standard_D2s_v3' // 2 vCPUs, 8 GB RAM
var osDiskSizeGB = 128
var imageReference = {
  publisher: 'MicrosoftWindowsDesktop'
  offer: 'windows-11'
  sku: 'win11-22h2-pro'
  version: 'latest'
}

// NIC configuration
resource clientVmNic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${resourceName}-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
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

// Client VM
resource clientVm 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: resourceName
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
      computerName: computerName
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
          id: clientVmNic.id
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

// Domain join and install tools
resource clientVmConfig 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: clientVm
  name: 'JoinDomainAndConfig'
  location: location
  tags: tags
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "Start-Sleep -Seconds 60; $securePassword = ConvertTo-SecureString \'${adminPassword}\' -AsPlainText -Force; $credential = New-Object System.Management.Automation.PSCredential(\'${domainName}\\${adminUsername}\', $securePassword); Add-Computer -DomainName \'${domainName}\' -Credential $credential -Restart:$false -Force; Restart-Computer -Force"'
    }
  }
}

// Outputs
output clientVmName string = resourceName
output clientVmPrivateIp string = clientVmNic.properties.ipConfigurations[0].properties.privateIPAddress 
