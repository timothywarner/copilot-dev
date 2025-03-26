# Windows Server 2025 Learning Lab
# Primary Domain Controller Setup Script

param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$AdminUser,
    
    [Parameter(Mandatory=$true)]
    [string]$AdminPassword
)

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force

# Start transcript for logging
Start-Transcript -Path "C:\Logs\addc1-setup.log" -Append

# Create log directory if it doesn't exist
if (!(Test-Path "C:\Logs")) {
    New-Item -Path "C:\Logs" -ItemType Directory
}

Write-Output "Starting Primary Domain Controller configuration..."

# Configure static IP
Write-Output "Configuring network settings..."
$networkConfig = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1
Set-NetIPInterface -InterfaceAlias $networkConfig.Name -Dhcp Disabled
# We don't need to set static IP since it's already done via ARM template

# Install AD DS role and management tools
Write-Output "Installing AD DS role and management tools..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Create AD forest and domain
Write-Output "Creating AD forest and domain: $DomainName"
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $DomainName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true `
    -SafeModeAdministratorPassword $securePassword

# The server will restart automatically after forest creation

# Stop transcript
Stop-Transcript 