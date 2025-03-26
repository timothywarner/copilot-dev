# Windows Server 2025 Learning Lab
# Active Directory Certificate Services Setup Script

param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName
)

# Start transcript for logging
Start-Transcript -Path "C:\Logs\adcs-setup.log" -Append

# Create log directory if it doesn't exist
if (!(Test-Path "C:\Logs")) {
    New-Item -Path "C:\Logs" -ItemType Directory
}

Write-Output "Starting Active Directory Certificate Services configuration..."

# Install ADCS role and management tools
Write-Output "Installing ADCS role and management tools..."
Install-WindowsFeature -Name ADCS-Cert-Authority, ADCS-Web-Enrollment, ADCS-Enroll-Web-Svc, ADCS-Web-Enrollment -IncludeManagementTools

# Configure ADCS as Enterprise CA
Write-Output "Configuring ADCS as Enterprise CA..."
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA `
    -CACommonName "$DomainName-CA" `
    -CADistinguishedNameSuffix "DC=$($DomainName.Split('.')[0]),DC=$($DomainName.Split('.')[1])" `
    -ValidityPeriod Years -ValidityPeriodUnits 5 `
    -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
    -KeyLength 2048 `
    -HashAlgorithmName SHA256 `
    -Force

# Configure Web Enrollment
Write-Output "Configuring Web Enrollment..."
Install-AdcsWebEnrollment -Force

# Configure Certificate Enrollment Web Service
Write-Output "Configuring Certificate Enrollment Web Service..."
Install-AdcsEnrollmentWebService -AuthenticationType Kerberos -Force

# Configure basic certificate templates
Write-Output "Configuring certificate templates..."
# This part would normally involve setting up certificate templates through the GUI
# For automation, we'll use PowerShell to export and import template configuration

# Restart Certificate Services for changes to take effect
Write-Output "Restarting Certificate Services..."
Restart-Service -Name CertSvc

Write-Output "AD Certificate Services configuration complete."

# Stop transcript
Stop-Transcript 