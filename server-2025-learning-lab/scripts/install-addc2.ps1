# Windows Server 2025 Learning Lab
# Secondary Domain Controller Setup Script

param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$AdminUser,
    
    [Parameter(Mandatory=$true)]
    [string]$AdminPassword,
    
    [Parameter(Mandatory=$true)]
    [string]$PrimaryDC
)

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$DomainName\$AdminUser", $securePassword)

# Start transcript for logging
Start-Transcript -Path "C:\Logs\addc2-setup.log" -Append

# Create log directory if it doesn't exist
if (!(Test-Path "C:\Logs")) {
    New-Item -Path "C:\Logs" -ItemType Directory
}

Write-Output "Starting Secondary Domain Controller configuration..."

# Configure static IP and DNS
Write-Output "Configuring network settings..."
$networkConfig = Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceAlias $networkConfig.Name -ServerAddresses $PrimaryDC

# Install AD DS role and management tools
Write-Output "Installing AD DS role and management tools..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Wait for domain to be available
Write-Output "Waiting for domain $DomainName to be available..."
$attempts = 0
$maxAttempts = 30
$success = $false

while ($attempts -lt $maxAttempts -and -not $success) {
    try {
        Test-Connection -ComputerName $PrimaryDC -Count 1 -ErrorAction Stop
        $ping = $true
    } catch {
        $ping = $false
    }
    
    try {
        Resolve-DnsName -Name $DomainName -ErrorAction Stop
        $dns = $true
    } catch {
        $dns = $false
    }
    
    if ($ping -and $dns) {
        $success = $true
        Write-Output "Domain controller is reachable."
    } else {
        $attempts++
        Write-Output "Waiting for domain controller to be available... Attempt $attempts of $maxAttempts"
        Start-Sleep -Seconds 30
    }
}

if (-not $success) {
    Write-Error "Could not connect to domain controller after $maxAttempts attempts. Exiting."
    Stop-Transcript
    exit 1
}

# Promote to domain controller
Write-Output "Promoting server to domain controller in domain: $DomainName"
Install-ADDSDomainController `
    -DomainName $DomainName `
    -InstallDns:$true `
    -Credential $credential `
    -SafeModeAdministratorPassword $securePassword `
    -NoRebootOnCompletion:$false `
    -Force:$true

# The server will restart automatically after promotion

# Stop transcript
Stop-Transcript 