# Troubleshooting Guide

This guide provides solutions to common issues you might encounter when deploying and using the Windows Server 2025 Learning Lab.

## Deployment Issues

### Azure Deployment Fails

**Symptoms:**
- Deployment script fails with an error
- Resources are not created in Azure

**Possible Causes & Solutions:**

1. **Insufficient Permissions**
   - Ensure you have Contributor or Owner role on the subscription.
   - Try running `az login` to re-authenticate.

2. **Resource Quota Limits**
   - Azure free trial accounts have limited quotas.
   - Check if you have reached your VM quota limit.
   - Solution: Request a quota increase or use a different subscription.

3. **Invalid Parameters**
   - Password doesn't meet complexity requirements (12+ characters, mix of uppercase, lowercase, numbers, and special characters).
   - Solution: Use a more complex password or let the script generate one for you.

4. **Region Availability**
   - Windows Server 2025 images might not be available in all regions.
   - Solution: Choose a different region (East US or West US are recommended).

### VM Provisioning Timeout

**Symptoms:**
- Deployment takes longer than expected
- VMs show as "Creating" for more than 30 minutes

**Possible Causes & Solutions:**

1. **Azure Service Issues**
   - Check the [Azure Status page](https://status.azure.com) for any ongoing issues.
   - Wait and try again later.

2. **Network Connectivity**
   - Ensure you have a stable internet connection.
   - Try connecting to Azure from a different network.

## Domain Controller Issues

### Domain Controller Configuration Fails

**Symptoms:**
- AD DS installation fails
- Domain is not created

**Possible Causes & Solutions:**

1. **Script Execution Issues**
   - Check the VM extension logs in the Azure portal.
   - Connect to the VM using Bastion and check C:\Logs for detailed error logs.
   - Solution: Manually run the setup script on the DC.

2. **DNS Configuration**
   - Ensure the DNS settings are properly configured.
   - Solution: Manually configure DNS settings on the network adapter.

### Domain Join Issues

**Symptoms:**
- Member server or client VM fails to join the domain
- "The network path was not found" error

**Possible Causes & Solutions:**

1. **DNS Resolution**
   - Ensure the VMs are using the domain controller as their DNS server.
   - Solution: Set DNS manually on the VM.

2. **Timing Issues**
   - Domain controller might not be fully promoted when join is attempted.
   - Solution: Wait a few minutes and try again.

3. **Credential Issues**
   - Ensure you're using the correct domain admin credentials.
   - Solution: Reset the admin password in Key Vault.

## Network Issues

### VM Connectivity Problems

**Symptoms:**
- VMs cannot communicate with each other
- Ping or RDP fails between VMs

**Possible Causes & Solutions:**

1. **NSG Rules**
   - Check Network Security Group rules for any blocked ports.
   - Solution: Modify NSG rules to allow necessary traffic.

2. **Routing Issues**
   - Verify that the VNet and subnet configurations are correct.
   - Solution: Check the effective routes for the VMs.

### Bastion Connection Issues

**Symptoms:**
- Cannot connect to VMs using Azure Bastion
- Bastion shows loading or error

**Possible Causes & Solutions:**

1. **Browser Issues**
   - Try using a different browser (Chrome or Edge recommended).
   - Clear browser cache and cookies.

2. **Popup Blocker**
   - Disable popup blockers as they may interfere with Bastion.

3. **Azure Portal Issues**
   - Try accessing Bastion directly from the VM page in the Azure portal.

## Software Installation Issues

### Tool Installation Fails

**Symptoms:**
- Git, VS Code, or other tools are not installed properly
- Chocolatey installation fails

**Possible Causes & Solutions:**

1. **Internet Access Issues**
   - Ensure VMs have internet access for downloading packages.
   - Solution: Check NSG outbound rules.

2. **Script Execution Policy**
   - PowerShell execution policy might be restricting scripts.
   - Solution: Set execution policy to Bypass for the script.

3. **Disk Space**
   - Check if there's enough disk space for installations.
   - Solution: Clean up unnecessary files or increase disk size.

## Additional Support

If you encounter issues not covered in this guide:

1. Check the GitHub repository issues section for similar problems and solutions.
2. Open a new issue with detailed information about the problem, including:
   - Error messages
   - Steps to reproduce
   - Azure region used
   - Logs from C:\Logs on affected VMs

3. For urgent Azure-related issues, contact [Azure Support](https://azure.microsoft.com/support/options/). 