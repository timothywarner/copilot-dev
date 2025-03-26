# Windows Server 2025 Learning Lab
# Client VM Setup Script

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
$credential = New-Object System.Management.Automation.PSCredential("$DomainName\$AdminUser", $securePassword)

# Start transcript for logging
Start-Transcript -Path "C:\Logs\client-setup.log" -Append

# Create log directory if it doesn't exist
if (!(Test-Path "C:\Logs")) {
    New-Item -Path "C:\Logs" -ItemType Directory
}

Write-Output "Starting Client VM configuration..."

# Wait a bit to ensure the domain is reachable
Start-Sleep -Seconds 60

# Join the domain
Write-Output "Joining domain: $DomainName"
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
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online

# Install SSH Client
Write-Output "Installing SSH Client..."
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~

# Create desktop shortcuts for lab resources
Write-Output "Creating desktop shortcuts..."
$desktop = [Environment]::GetFolderPath("Desktop")

# Create shortcut to DC1
$shortcutPath = "$desktop\Domain Controller.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "%windir%\system32\mstsc.exe"
$shortcut.Arguments = "/v:dc1.$DomainName"
$shortcut.Description = "Connect to Domain Controller"
$shortcut.IconLocation = "%SystemRoot%\System32\shell32.dll,16"
$shortcut.Save()

# Create shortcut to Member Server
$shortcutPath = "$desktop\Member Server.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "%windir%\system32\mstsc.exe"
$shortcut.Arguments = "/v:mem.$DomainName"
$shortcut.Description = "Connect to Member Server"
$shortcut.IconLocation = "%SystemRoot%\System32\shell32.dll,16"
$shortcut.Save()

# Create shortcut to Member Server's website
$shortcutPath = "$desktop\Member Server Website.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "http://mem.$DomainName"
$shortcut.Description = "Open Member Server Website"
$shortcut.IconLocation = "%ProgramFiles%\Internet Explorer\iexplore.exe,0"
$shortcut.Save()

# Create shortcut to Windows Admin Center
$shortcutPath = "$desktop\Windows Admin Center.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "https://dc1.$DomainName"
$shortcut.Description = "Open Windows Admin Center"
$shortcut.IconLocation = "%SystemRoot%\System32\shell32.dll,18"
$shortcut.Save()

# Install Git, GitHub CLI, VS Code, PowerShell 7, Node.js, Python and Azure CLI
Write-Output "Installing development tools..."

# Set execution policy for script execution
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey package manager
Write-Output "Installing Chocolatey..."
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Refresh environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install packages with Chocolatey
Write-Output "Installing packages with Chocolatey..."
choco install git -y
choco install gh -y
choco install vscode -y
choco install pwsh -y
choco install nodejs-lts -y
choco install python -y
choco install azure-cli -y
choco install bicep -y
choco install azurecli -y
choco install az.powershell -y

# Refresh environment after installs
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Create a simple README on the desktop
$readmePath = "$desktop\README.txt"
$readmeContent = @"
# Windows Server 2025 Learning Lab

Welcome to the Windows Server 2025 Learning Lab environment!

## Environment Components:

1. Domain Controller (DC1):
   - Running Windows Server 2025
   - Domain Name: $DomainName
   - Roles: AD DS, DNS, AD CS
   - Access via RDP: dc1.$DomainName

2. Secondary Domain Controller (DC2):
   - Running Windows Server 2025
   - Domain Name: $DomainName
   - Roles: AD DS, DNS
   - Access via RDP: dc2.$DomainName

3. Member Server (MEM):
   - Running Windows Server 2025
   - Roles: IIS
   - Access via RDP: mem.$DomainName
   - Website: http://mem.$DomainName

4. Client VM (This Machine):
   - Running Windows 11
   - Joined to $DomainName domain
   - Includes all necessary management tools

## Default Credentials:

- Domain Admin: $DomainName\$AdminUser
  (For other user accounts, check Active Directory Users and Computers)

## Tools Installed:

- PowerShell 7
- Git
- GitHub CLI
- Visual Studio Code
- Node.js
- Python
- Azure CLI
- Azure PowerShell
- Bicep

Enjoy exploring Windows Server 2025!
"@

Set-Content -Path $readmePath -Value $readmeContent

Write-Output "Client VM configuration complete. Restarting computer to apply changes..."

# Stop transcript
Stop-Transcript

# Restart the computer to complete domain join and apply settings
Restart-Computer -Force 