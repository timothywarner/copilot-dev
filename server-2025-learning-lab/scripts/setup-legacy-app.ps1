# Legacy App Setup Script
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$false)]
    [string]$LogPath = "C:\Logs\LegacyApp-Setup.log"
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

# Install IIS and ASP.NET features
Write-Log "Installing IIS and ASP.NET features..."
$features = @(
    'Web-Server',
    'Web-Windows-Auth',
    'Web-ASP-Net45',
    'Web-Net-Ext45',
    'Web-ISAPI-Ext',
    'Web-ISAPI-Filter',
    'NET-Framework-45-Features',
    'WAS-Process-Model',
    'WAS-Config-APIs'
)

Install-WindowsFeature -Name $features -IncludeManagementTools

# Create demo application
$appPath = "C:\inetpub\wwwroot\LegacyApp"
New-Item -ItemType Directory -Path $appPath -Force

# Create web.config
$webConfig = @"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
    <system.web>
        <authentication mode="Windows" />
        <identity impersonate="true" />
        <compilation debug="true" targetFramework="4.8" />
    </system.web>
    <system.webServer>
        <security>
            <authentication>
                <windowsAuthentication enabled="true">
                    <providers>
                        <add value="Negotiate" />
                        <add value="NTLM" />
                    </providers>
                </windowsAuthentication>
                <anonymousAuthentication enabled="false" />
            </authentication>
        </security>
        <handlers>
            <add name="ASPClassic" path="*.asp" verb="*" modules="IsapiModule" scriptProcessor="%windir%\system32\inetsrv\asp.dll" resourceType="File" />
        </handlers>
    </system.webServer>
    <connectionStrings>
        <add name="DefaultConnection" 
             connectionString="Server=localhost;Database=LegacyApp;Trusted_Connection=True;Integrated Security=True"
             providerName="System.Data.SqlClient" />
    </connectionStrings>
</configuration>
"@

Set-Content -Path "$appPath\web.config" -Value $webConfig

# Create demo page
$demoPage = @"
<%@ Page Language="C#" %>
<%@ Import Namespace="System.DirectoryServices.AccountManagement" %>
<!DOCTYPE html>
<html>
<head>
    <title>Legacy App - Employee Directory</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background: #0078d4; color: white; padding: 20px; }
        .content { padding: 20px; }
        .user-info { background: #f0f0f0; padding: 10px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Employee Directory</h1>
        <p>Authenticated as: <%= User.Identity.Name %></p>
    </div>
    <div class="content">
        <h2>Domain Users</h2>
        <%
            using (var context = new PrincipalContext(ContextType.Domain))
            {
                using (var searcher = new PrincipalSearcher(new UserPrincipal(context)))
                {
                    var users = searcher.FindAll();
                    foreach (UserPrincipal user in users)
                    {
                        if (user.DisplayName != null)
                        {
            %>
                        <div class="user-info">
                            <strong>Name:</strong> <%= user.DisplayName %><br/>
                            <strong>Email:</strong> <%= user.EmailAddress %><br/>
                            <strong>Last Logon:</strong> <%= user.LastLogon %>
                        </div>
            <%
                        }
                    }
                }
            }
        %>
    </div>
</body>
</html>
"@

Set-Content -Path "$appPath\default.aspx" -Value $demoPage -Encoding UTF8

# Configure IIS
Write-Log "Configuring IIS application..."
Import-Module WebAdministration

# Create application pool
$appPoolName = "LegacyAppPool"
New-WebAppPool -Name $appPoolName
Set-ItemProperty IIS:\AppPools\$appPoolName -name "managedRuntimeVersion" -value "v4.0"
Set-ItemProperty IIS:\AppPools\$appPoolName -name "managedPipelineMode" -value "Integrated"
Set-ItemProperty IIS:\AppPools\$appPoolName -name "processModel.identityType" -value "NetworkService"

# Create website
New-Website -Name "LegacyApp" -PhysicalPath $appPath -ApplicationPool $appPoolName -Force

# Configure Kerberos SPN
$computerName = [System.Net.Dns]::GetHostName()
$fqdn = "$computerName.$DomainName"
setspn -S HTTP/$fqdn $computerName

Write-Log "Legacy app setup completed successfully"

# Output configuration details
Write-Log @"
Legacy App Configuration:
------------------------
URL: https://$fqdn/LegacyApp
Authentication: Windows (Kerberos)
App Pool: $appPoolName
Physical Path: $appPath
"@ 