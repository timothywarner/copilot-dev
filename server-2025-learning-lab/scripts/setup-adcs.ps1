# Enterprise CA Setup and Certificate Template Configuration
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$CACommonName = "WS2025Lab-RootCA",
    
    [Parameter(Mandatory=$false)]
    [string]$LogPath = "C:\Logs\ADCS-Setup.log"
)

# Create log directory if it doesn't exist
$logDir = Split-Path $LogPath -Parent
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Write-Log {
    param($Message)
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    Add-Content -Path $LogPath -Value $logMessage
    Write-Host $logMessage
}

function Install-EnterpriseCA {
    try {
        Write-Log "Installing ADCS and Web Enrollment roles..."
        Install-WindowsFeature -Name ADCS-Cert-Authority, ADCS-Web-Enrollment -IncludeManagementTools

        Write-Log "Configuring Enterprise Root CA..."
        $caParams = @{
            CAType = 'EnterpriseRootCA'
            CACommonName = $CACommonName
            ValidityPeriod = 'Years'
            ValidityPeriodUnits = 5
            CryptoProviderName = 'RSA#Microsoft Software Key Storage Provider'
            KeyLength = 4096
            HashAlgorithmName = 'SHA256'
            Force = $true
        }
        Install-AdcsCertificationAuthority @caParams
        
        Write-Log "Configuring Web Enrollment..."
        Install-AdcsWebEnrollment -Force

        return $true
    }
    catch {
        Write-Log "Error installing CA: $_"
        return $false
    }
}

function New-CertificateTemplate {
    param(
        [string]$TemplateName,
        [string]$DisplayName,
        [string]$OID,
        [string[]]$EnhancedKeyUsage,
        [bool]$RequiresManagerApproval = $false
    )
    
    try {
        Write-Log "Creating certificate template: $DisplayName"
        
        # Create template in AD
        $ldapPath = "CN=Certificate Templates,CN=Public Key Services,CN=Services,CN=Configuration,DC=$($DomainName.Split('.')[0]),DC=$($DomainName.Split('.')[1])"
        $template = New-Object -TypeName System.DirectoryServices.DirectoryEntry("LDAP://$ldapPath")
        
        # Enable template
        $configContext = ([ADSI]"LDAP://RootDSE").configurationNamingContext
        $pkiContainer = [ADSI]"LDAP://CN=Certificate Templates,CN=Public Key Services,CN=Services,$configContext"
        $pkiContainer.Children.Add("CN=$TemplateName", "pKICertificateTemplate")
        
        Write-Log "Template $DisplayName created successfully"
        return $true
    }
    catch {
        Write-Log "Error creating template $DisplayName: $_"
        return $false
    }
}

function Set-AutoEnrollment {
    try {
        Write-Log "Configuring certificate auto-enrollment..."
        
        # Create GPO
        $gpoName = "WS2025Lab Certificate Auto-enrollment"
        New-GPO -Name $gpoName -Comment "Enables automatic certificate enrollment for computers and users"
        
        # Configure auto-enrollment settings
        $gpoPath = "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\AutoEnrollment"
        Set-GPRegistryValue -Name $gpoName -Key $gpoPath -ValueName "AEPolicy" -Type DWord -Value 7
        Set-GPRegistryValue -Name $gpoName -Key $gpoPath -ValueName "OfflineExpirationPercent" -Type DWord -Value 10
        
        # Link GPO to domain
        $domainDN = "DC=$($DomainName.Split('.')[0]),DC=$($DomainName.Split('.')[1])"
        New-GPLink -Name $gpoName -Target $domainDN -LinkEnabled Yes
        
        Write-Log "Auto-enrollment configured successfully"
        return $true
    }
    catch {
        Write-Log "Error configuring auto-enrollment: $_"
        return $false
    }
}

# Main execution
Write-Log "Starting ADCS setup for domain: $DomainName"

# Install and configure Enterprise CA
if (-not (Install-EnterpriseCA)) {
    Write-Log "Failed to install Enterprise CA. Exiting."
    exit 1
}

# Create certificate templates
$templates = @(
    @{
        Name = 'WS2025LabWebServer'
        DisplayName = 'WS2025 Lab Web Server'
        OID = '1.3.6.1.4.1.311.21.8.16735937.1234567.1111111.1111111'
        EnhancedKeyUsage = @('Server Authentication', 'Client Authentication')
    },
    @{
        Name = 'WS2025LabSSHKey'
        DisplayName = 'WS2025 Lab SSH Authentication'
        OID = '1.3.6.1.4.1.311.21.8.16735937.1234567.2222222.2222222'
        EnhancedKeyUsage = @('Client Authentication')
    }
)

foreach ($template in $templates) {
    if (-not (New-CertificateTemplate @template)) {
        Write-Log "Failed to create template $($template.DisplayName). Continuing..."
    }
}

# Configure auto-enrollment
if (-not (Set-AutoEnrollment)) {
    Write-Log "Failed to configure auto-enrollment. Exiting."
    exit 1
}

Write-Log "ADCS setup completed successfully"

# Create certificate distribution script
$certScript = @"
# Certificate Request and Configuration Script
`$ErrorActionPreference = 'Stop'
`$logFile = 'C:\Logs\Certificate-Setup.log'

function Write-Log {
    param(`$Message)
    `$logMessage = "`$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): `$Message"
    Add-Content -Path `$logFile -Value `$logMessage
    Write-Host `$logMessage
}

try {
    Write-Log 'Starting certificate configuration'
    
    # Get machine FQDN
    `$computerName = [System.Net.Dns]::GetHostName()
    `$domainName = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
    `$fqdn = "`$computerName.`$domainName"
    
    # Request Web Server cert
    Write-Log 'Requesting Web Server certificate'
    certreq -enroll -machine -q "WS2025LabWebServer"
    
    # Configure services based on installed roles
    if (Get-Service sshd -ErrorAction SilentlyContinue) {
        Write-Log 'Configuring SSHD certificate'
        certreq -enroll -machine -q "WS2025LabSSHKey"
        
        `$sshConfig = @'
PubkeyAuthentication yes
HostKey __MACHINE_SSH_CERT_PATH__
'@
        Set-Content -Path 'C:\ProgramData\ssh\sshd_config' -Value `$sshConfig
        Restart-Service sshd
    }
    
    if (Get-Service W3SVC -ErrorAction SilentlyContinue) {
        Write-Log 'Configuring IIS certificate binding'
        Import-Module WebAdministration
        Get-ChildItem -Path Cert:\LocalMachine\My |
            Where-Object {`$_.Subject -match `$fqdn} |
            Select-Object -First 1 |
            ForEach-Object {
                New-Item -Path "IIS:\SslBindings\0.0.0.0:443" -Value `$_ -Force
            }
    }
    
    Write-Log 'Certificate configuration completed successfully'
}
catch {
    Write-Log "Error during certificate configuration: `$_"
    exit 1
}
"@

Set-Content -Path "C:\Scripts\Configure-Certificates.ps1" -Value $certScript
Write-Log "Certificate configuration script created at C:\Scripts\Configure-Certificates.ps1" 