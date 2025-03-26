# Windows Server 2025 Learning Lab
# Member Server Setup Script

param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$AdminUser,
    
    [Parameter(Mandatory=$true)]
    [string]$AdminPassword,

    [Parameter(Mandatory=$false)]
    [bool]$InstallDevTools = $true
)

# Function to write status
function Write-Status {
    param([string]$Message)
    Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
}

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("$DomainName\$AdminUser", $securePassword)

# Start transcript for logging
Start-Transcript -Path "C:\Logs\member-server-setup.log" -Append

# Create log directory if it doesn't exist
if (!(Test-Path "C:\Logs")) {
    New-Item -Path "C:\Logs" -ItemType Directory
}

Write-Status "Starting member server configuration..."

# Wait a bit to ensure the domain is reachable
Start-Sleep -Seconds 60

# Join the domain
Write-Status "Joining domain $DomainName..."
try {
    Add-Computer -DomainName $DomainName -Credential $credential -Restart:$false -Force
    Write-Output "Successfully joined domain $DomainName"
} catch {
    Write-Error "Failed to join domain: $_"
    Stop-Transcript
    exit 1
}

# Install RSAT tools
Write-Output "Installing RSAT tools..."
Install-WindowsFeature -Name RSAT-AD-Tools, RSAT-DNS-Server

# Install SSH Server
Write-Output "Installing SSH Server..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~

# Start and configure SSH service
Write-Output "Configuring SSH Service..."
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# Enable PowerShell remoting
Write-Output "Enabling PowerShell remoting..."
Enable-PSRemoting -Force

# Install IIS with basic features
Write-Output "Installing IIS with basic features..."
Install-WindowsFeature -Name Web-Server, Web-Mgmt-Tools, Web-App-Dev, Web-Net-Ext45, Web-ASP, Web-ASP-NET45

# Create a simple landing page
Write-Output "Creating a simple landing page..."
$iisPath = "C:\inetpub\wwwroot"
$indexHtmlPath = "$iisPath\index.html"

$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Windows Server 2025 Learning Lab</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #0078d7;
            color: white;
        }
        .container {
            text-align: center;
            padding: 2rem;
            max-width: 800px;
            background-color: rgba(0, 0, 0, 0.4);
            border-radius: 8px;
        }
        h1 {
            margin-bottom: 1rem;
        }
        p {
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }
        .server-info {
            margin-top: 2rem;
            padding: 1rem;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
            text-align: left;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Windows Server 2025 Learning Lab</h1>
        <p>Welcome to the Member Server in the Windows Server 2025 Learning Lab environment.</p>
        <p>This server is joined to the domain <strong>$DomainName</strong> and is configured with IIS.</p>
        
        <div class="server-info">
            <p><strong>Server Name:</strong> $env:COMPUTERNAME</p>
            <p><strong>IP Address:</strong> $((Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet*).IPAddress)</p>
            <p><strong>Domain:</strong> $DomainName</p>
            <p><strong>Operating System:</strong> $((Get-CimInstance Win32_OperatingSystem).Caption)</p>
            <p><strong>Current Time:</strong> <span id="current-time"></span></p>
        </div>
    </div>

    <script>
        function updateTime() {
            document.getElementById('current-time').innerText = new Date().toLocaleString();
        }
        updateTime();
        setInterval(updateTime, 1000);
    </script>
</body>
</html>
"@

Set-Content -Path $indexHtmlPath -Value $htmlContent

if ($InstallDevTools) {
    Write-Status "Installing development tools..."
    
    # Install Chocolatey
    Write-Status "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    
    # Refresh env vars
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # Install tools using Chocolatey
    $tools = @(
        'powershell-core'
        'git'
        'gh'
        'vscode'
        'nodejs-lts'
        'python311'
        'azure-cli'
        'microsoft-windows-terminal'
    )
    
    foreach ($tool in $tools) {
        Write-Status "Installing $tool..."
        choco install $tool -y --no-progress
    }
    
    # Install Azure Development CLI (azd)
    Write-Status "Installing Azure Developer CLI (azd)..."
    winget install Microsoft.Azd --accept-source-agreements --accept-package-agreements
    
    # Install Bicep
    Write-Status "Installing Bicep..."
    az bicep install
    
    # Install GitHub Copilot CLI
    Write-Status "Installing GitHub Copilot CLI..."
    npm install -g @githubnext/github-copilot-cli
    
    # Configure Git
    Write-Status "Configuring Git defaults..."
    git config --system core.longpaths true
    git config --system core.autocrlf true
    
    # Install Windows Admin Center
    Write-Status "Installing Windows Admin Center..."
    $wacUrl = "https://aka.ms/WACDownload"
    $wacInstaller = "$env:TEMP\WindowsAdminCenter.msi"
    Invoke-WebRequest -Uri $wacUrl -OutFile $wacInstaller
    Start-Process msiexec.exe -ArgumentList "/i $wacInstaller /qn /L*v wac-install.log SME_PORT=443 SSL_CERTIFICATE_OPTION=generate" -Wait
    
    Write-Status "Development tools installation complete!"
}

Write-Status "Configuration complete! Restart required."

# Stop transcript
Stop-Transcript

# Restart the computer to complete domain join and apply settings
Restart-Computer -Force 