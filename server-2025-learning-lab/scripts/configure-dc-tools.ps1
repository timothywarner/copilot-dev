# Windows Server 2025 Learning Lab
# Configure DC with additional tools and demo environment

param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName
)

# Start transcript for logging
Start-Transcript -Path "C:\Logs\configure-tools.log" -Append

# Create log directory if it doesn't exist
if (!(Test-Path "C:\Logs")) {
    New-Item -Path "C:\Logs" -ItemType Directory
}

Write-Output "Starting additional tools and demo environment configuration..."

# Wait for AD DS to be fully operational
Write-Output "Waiting for AD DS to be fully operational..."
$attempts = 0
$maxAttempts = 30
$success = $false

while ($attempts -lt $maxAttempts -and -not $success) {
    try {
        Get-ADDomain -ErrorAction Stop
        $success = $true
        Write-Output "AD DS is operational."
    } catch {
        $attempts++
        Write-Output "Waiting for AD DS to be operational... Attempt $attempts of $maxAttempts"
        Start-Sleep -Seconds 10
    }
}

if (-not $success) {
    Write-Error "AD DS is not operational after $maxAttempts attempts. Continuing with setup anyway."
}

# Install RSAT tools for comprehensive management
Write-Output "Installing RSAT tools..."
Install-WindowsFeature -Name RSAT-AD-Tools, RSAT-DNS-Server, RSAT-DHCP, RSAT-ADCS, RSAT-ADCS-Mgmt

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

# Create demo OUs for different purposes
Write-Output "Creating demo organizational units..."
$BaseDN = "DC=$($DomainName.Split('.')[0]),DC=$($DomainName.Split('.')[1])"

New-ADOrganizationalUnit -Name "Departments" -Path $BaseDN
New-ADOrganizationalUnit -Name "IT" -Path "OU=Departments,$BaseDN"
New-ADOrganizationalUnit -Name "Finance" -Path "OU=Departments,$BaseDN"
New-ADOrganizationalUnit -Name "HR" -Path "OU=Departments,$BaseDN"
New-ADOrganizationalUnit -Name "Marketing" -Path "OU=Departments,$BaseDN"

New-ADOrganizationalUnit -Name "Security Groups" -Path $BaseDN
New-ADOrganizationalUnit -Name "Service Accounts" -Path $BaseDN
New-ADOrganizationalUnit -Name "Computers" -Path $BaseDN
New-ADOrganizationalUnit -Name "Servers" -Path "OU=Computers,$BaseDN"
New-ADOrganizationalUnit -Name "Workstations" -Path "OU=Computers,$BaseDN"

# Create demo users
Write-Output "Creating demo users..."

$departments = @("IT", "Finance", "HR", "Marketing")
$userCount = 5

foreach ($dept in $departments) {
    for ($i=1; $i -le $userCount; $i++) {
        $username = "$($dept.ToLower())user$i"
        $displayName = "$dept User $i"
        $userPrincipalName = "$username@$DomainName"
        $securePassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force
        
        New-ADUser -Name $displayName `
            -GivenName "$dept" `
            -Surname "User$i" `
            -SamAccountName $username `
            -UserPrincipalName $userPrincipalName `
            -DisplayName $displayName `
            -Path "OU=$dept,OU=Departments,$BaseDN" `
            -AccountPassword $securePassword `
            -ChangePasswordAtLogon $false `
            -Enabled $true
        
        Write-Output "Created user: $username"
    }
}

# Create admin user for lab exercises
$adminUsername = "LabAdmin"
$adminPassword = ConvertTo-SecureString "LabAdmin123!" -AsPlainText -Force
New-ADUser -Name "Lab Administrator" `
    -GivenName "Lab" `
    -Surname "Administrator" `
    -SamAccountName $adminUsername `
    -UserPrincipalName "$adminUsername@$DomainName" `
    -DisplayName "Lab Administrator" `
    -Path "OU=IT,OU=Departments,$BaseDN" `
    -AccountPassword $adminPassword `
    -ChangePasswordAtLogon $false `
    -Enabled $true

Add-ADGroupMember -Identity "Domain Admins" -Members $adminUsername
Write-Output "Created admin user: $adminUsername and added to Domain Admins"

# Create security groups
Write-Output "Creating security groups..."
$groups = @(
    @{Name="IT-Admins"; Description="IT Administrators"},
    @{Name="Finance-Users"; Description="Finance Department Users"},
    @{Name="HR-Users"; Description="Human Resources Department Users"},
    @{Name="Marketing-Users"; Description="Marketing Department Users"}
)

foreach ($group in $groups) {
    New-ADGroup -Name $group.Name `
        -Description $group.Description `
        -GroupScope Global `
        -GroupCategory Security `
        -Path "OU=Security Groups,$BaseDN"
    
    Write-Output "Created group: $($group.Name)"
}

# Add department users to corresponding groups
Add-ADGroupMember -Identity "IT-Admins" -Members (Get-ADUser -Filter "SamAccountName -like 'ituser*'")
Add-ADGroupMember -Identity "Finance-Users" -Members (Get-ADUser -Filter "SamAccountName -like 'financeuser*'")
Add-ADGroupMember -Identity "HR-Users" -Members (Get-ADUser -Filter "SamAccountName -like 'hruser*'")
Add-ADGroupMember -Identity "Marketing-Users" -Members (Get-ADUser -Filter "SamAccountName -like 'marketinguser*'")

Write-Output "Added users to their respective groups"

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

# Refresh environment after installs
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install Windows Admin Center
Write-Output "Downloading Windows Admin Center..."
$wacInstallerUrl = "https://aka.ms/wacdownload"
$wacInstallerPath = "C:\Temp\WindowsAdminCenter.msi"

# Create temp directory if it doesn't exist
if (!(Test-Path "C:\Temp")) {
    New-Item -Path "C:\Temp" -ItemType Directory
}

# Download Windows Admin Center
Invoke-WebRequest -Uri $wacInstallerUrl -OutFile $wacInstallerPath

# Install Windows Admin Center
Write-Output "Installing Windows Admin Center..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $wacInstallerPath /qn /L*v C:\Logs\wac-install.log SME_PORT=443 SSL_CERTIFICATE_OPTION=generate" -Wait

Write-Output "Tools installation and demo environment configuration complete."

# Stop transcript
Stop-Transcript 