# Windows Server 2025 Learning Lab 🚀

A turnkey solution for exploring Windows Server 2025 in Azure. This lab provides a complete Active Directory environment with development tools pre-installed, following Cloud Adoption Framework (CAF) best practices.

## What You Get 🎁

- 2 Domain Controllers (Primary + Secondary)
  - Enterprise Root CA for SSL/TLS and SSH certificates
  - Automatic certificate enrollment
- 2 Member Servers
  - Development tools server with Windows Admin Center
  - Legacy app server (IIS + Classic ASP.NET)
- 2 Client VMs for testing
- Secure networking with Azure Bastion
- Pre-installed development environment
- CAF-aligned naming and security practices

### Pre-installed Developer Tools 🛠️

The member server comes loaded with:
- PowerShell 7
- Git + GitHub CLI
- Visual Studio Code
- Node.js LTS
- Python 3.11
- Azure CLI + Azure Developer CLI (azd)
- Bicep
- Windows Terminal
- Windows Admin Center v2
- GitHub Copilot CLI

## Quick Start 🏃‍♂️

### Prerequisites

1. An Azure subscription ([Start with $200 free credit](https://azure.microsoft.com/free))
2. Azure CLI installed on your machine
3. PowerShell 7+ or Azure Cloud Shell

### One-Click Deploy

```powershell
# Clone this repo
git clone https://github.com/timothywarner/server-2025-learning-lab
cd server-2025-learning-lab

# Deploy (PowerShell)
./deploy.ps1 -DomainName "yourdomain.local" -AdminUsername "labadmin"
```

That's it! The script will:
1. Create a resource group
2. Deploy the lab environment with CAF-compliant naming
3. Configure Active Directory
4. Install all dev tools
5. Provide you access information

### Azure Free Account Benefits 🎉
- [$200 credit for your first 30 days](https://azure.microsoft.com/free)
- 750 hours of Windows Server 2025 Azure Edition VM compute
- 55+ services that are always free
- No charges until you upgrade to pay-as-you-go
- [Detailed free account FAQ](https://azure.microsoft.com/free/free-account-faq)

### Cost Management 💰
- Using Azure Edition VMs for cost optimization
- Implements cost-effective networking with shared Bastion
- [Plan your costs with the Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/?service=virtual-machines)
- Remember to stop VMs when not in use!
- Set up [Azure Cost Management](https://learn.microsoft.com/azure/cost-management-billing/costs/cost-mgt-best-practices) alerts

## Lab Environment Details 🔍

### Network Layout
```
VNet (10.0.0.0/16)
├── AzureBastionSubnet (10.0.0.0/26)
│   └── Azure Bastion Host
├── AD Core Subnet (10.0.1.0/24)
│   ├── DC1 (10.0.1.4) - FSMO + Enterprise Root CA
│   └── DC2 (10.0.1.5) - Replica + DHCP
├── Application Subnet (10.0.2.0/24)
│   ├── Member Server (10.0.2.4) - Dev Tools + WAC
│   └── Legacy App (10.0.2.5) - IIS + Classic ASP.NET
└── Client Subnet (10.0.3.0/24)
    ├── Win11 Client (10.0.3.4)
    └── Win11 Client2 (10.0.3.5)
```

### Security Features
- Enterprise PKI with auto-enrollment
- No public IP addresses
- Azure Bastion for secure access
- NSG rules following least privilege
- Key Vault for credential management
- SSH key-based authentication
- Domain-issued TLS certificates

### Certificate Services
- Enterprise Root CA on DC1
- Automatic certificate enrollment
- Pre-configured templates for:
  - Web Server certificates
  - SSH authentication
  - User authentication
- Certificate-based SSH authentication
- Proper TLS for all web services

### Legacy App Features
- Classic ASP.NET Web Forms application
- Windows Authentication (Kerberos)
- SQL Server integration
- Perfect for testing:
  - Kerberos delegation
  - Double-hop authentication
  - Token size issues
  - Protocol transition

## Common Tasks 📋

### Connecting to VMs
```powershell
# Via Azure Portal
1. Go to the VM in Azure Portal
2. Click "Connect" -> "Bastion"
3. Enter credentials

# Via PowerShell
Connect-AzBastionSession -ResourceGroupName "rg-ws2025-lab" -VMName "vm-name"
```

### Stopping/Starting the Lab
```powershell
# Stop all VMs (PowerShell)
./scripts/stop-lab.ps1

# Start all VMs
./scripts/start-lab.ps1
```

### Accessing Windows Admin Center
1. Navigate to `https://memberserver:443`
2. Use your domain credentials

## Learning Resources 📚

- [Windows Server 2025 Documentation](https://docs.microsoft.com/windows-server)
- [Azure Virtual Machines Best Practices](https://docs.microsoft.com/azure/virtual-machines)
- [Active Directory Administration](https://docs.microsoft.com/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)

## Troubleshooting 🔧

### Common Issues

1. **Deployment Fails**
   - Check your subscription quota
   - Ensure you have contributor access
   - Verify region availability

2. **Can't Connect to VMs**
   - Wait 30 minutes after deployment (AD setup)
   - Verify Bastion is deployed
   - Check NSG rules

3. **Dev Tools Issues**
   - Run `choco upgrade all` for updates
   - Check Windows Admin Center logs
   - Verify domain connectivity

### Getting Help
- Open an issue in this repo
- Check Azure Portal Activity Log
- Review deployment logs in `C:\Logs`

## Contributing 🤝

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License 📄

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

---
Made with ❤️ for the Windows Server community
