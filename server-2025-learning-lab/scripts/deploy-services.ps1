# Main Service Deployment Orchestrator
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$false)]
    [string]$CACommonName = "WS2025Lab-RootCA",
    
    [Parameter(Mandatory=$false)]
    [string]$LogPath = "C:\Logs\Service-Deployment.log",

    [Parameter(Mandatory=$false)]
    [switch]$SkipADCS,

    [Parameter(Mandatory=$false)]
    [switch]$SkipLegacyApp,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force,
    
    [Parameter(Mandatory=$false)]
    [string]$StateFilePath = "C:\Logs\DeploymentState.json",
    
    [Parameter(Mandatory=$false)]
    [switch]$Debug
)

# Initialize logging
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
if ($Debug) {
    $DebugPreference = 'Continue'
}

# Ensure Scripts directory exists
$scriptsRoot = "C:\Scripts"
if (-not (Test-Path $scriptsRoot)) {
    New-Item -ItemType Directory -Path $scriptsRoot -Force | Out-Null
}

# Ensure Logs directory exists
$logDir = Split-Path $LogPath -Parent
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet('Info', 'Warning', 'Error', 'Debug')]
        [string]$Level = 'Info'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logMessage = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogPath -Value $logMessage
    
    switch ($Level) {
        'Info' { Write-Host $logMessage }
        'Warning' { Write-Host $logMessage -ForegroundColor Yellow }
        'Error' { Write-Host $logMessage -ForegroundColor Red }
        'Debug' { 
            if ($Debug) {
                Write-Host $logMessage -ForegroundColor Magenta
            }
        }
    }
}

# Function to manage deployment state
function Set-DeploymentState {
    param (
        [string]$Component,
        [string]$Status,
        [string]$Message = "",
        [hashtable]$AdditionalData = @{}
    )
    
    try {
        # Create or update state file
        if (Test-Path $StateFilePath) {
            $state = Get-Content -Path $StateFilePath -Raw | ConvertFrom-Json
            # Convert from PSCustomObject to hashtable if needed
            if ($state -isnot [hashtable]) {
                $newState = @{
                    LastUpdated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                    Components = @{}
                }
                foreach ($prop in $state.PSObject.Properties) {
                    if ($prop.Name -eq "Components") {
                        foreach ($comp in $state.Components.PSObject.Properties) {
                            $newState.Components[$comp.Name] = @{
                                Status = $state.Components.($comp.Name).Status
                                LastUpdated = $state.Components.($comp.Name).LastUpdated
                                Message = $state.Components.($comp.Name).Message
                                Data = $state.Components.($comp.Name).Data
                            }
                        }
                    } else {
                        $newState[$prop.Name] = $prop.Value
                    }
                }
                $state = $newState
            }
        } else {
            $state = @{
                LastUpdated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                Components = @{}
            }
        }
        
        # Update component state
        if (-not $state.Components.ContainsKey($Component)) {
            $state.Components[$Component] = @{}
        }
        
        $state.Components[$Component] = @{
            Status = $Status
            LastUpdated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            Message = $Message
            Data = $AdditionalData
        }
        
        $state.LastUpdated = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        
        # Save state to file (make sure directory exists)
        $stateDir = Split-Path $StateFilePath -Parent
        if (-not (Test-Path $stateDir)) {
            New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
        }
        
        $state | ConvertTo-Json -Depth 4 | Set-Content -Path $StateFilePath
        Write-Log "Updated deployment state for component '$Component': $Status" -Level Debug
        return $true
    } catch {
        Write-Log "Failed to update state file: $_" -Level Error
        return $false
    }
}

function Get-DeploymentState {
    param (
        [string]$Component
    )
    
    if (Test-Path $StateFilePath) {
        try {
            $state = Get-Content -Path $StateFilePath -Raw | ConvertFrom-Json
            if ($Component) {
                if ($state.Components.PSObject.Properties.Name -contains $Component) {
                    return $state.Components.$Component
                }
                return $null
            }
            return $state
        } catch {
            Write-Log "Failed to read state file: $_" -Level Error
            return $null
        }
    }
    return $null
}

function Test-Prerequisites {
    Write-Log "Checking prerequisites..."
    
    # Check if running as admin
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Log "Script must run with administrative privileges" -Level Error
        return $false
    }
    
    # Check domain membership
    try {
        $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
        Write-Log "Current domain: $($domain.Name)" -Level Debug
        if ($domain.Name -ne $DomainName) {
            Write-Log "Computer is not joined to the correct domain ($DomainName)" -Level Error
            return $false
        }
    }
    catch {
        Write-Log "Computer is not joined to a domain: $_" -Level Error
        return $false
    }
    
    # Check PowerShell version
    Write-Log "PowerShell version: $($PSVersionTable.PSVersion)" -Level Debug
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Log "PowerShell 5.0 or higher is required" -Level Error
        return $false
    }
    
    # Check network connectivity to domain controller
    try {
        $dcName = (Get-ADDomainController -Discover).HostName[0]
        Write-Log "Testing connectivity to domain controller: $dcName" -Level Debug
        if (Test-Connection -ComputerName $dcName -Count 1 -Quiet) {
            Write-Log "Successfully connected to domain controller" -Level Debug
        } else {
            Write-Log "Cannot connect to domain controller $dcName" -Level Error
            return $false
        }
    } catch {
        Write-Log "Error testing domain controller connectivity: $_" -Level Error
        return $false
    }
    
    Write-Log "All prerequisites met"
    return $true
}

function Deploy-ADCS {
    $adcsState = Get-DeploymentState -Component "ADCS"
    
    # Check if ADCS is already deployed and force is not specified
    if ($adcsState -and $adcsState.Status -eq "Completed" -and -not $Force) {
        Write-Log "ADCS is already deployed. Use -Force to redeploy." -Level Warning
        return $true
    }
    
    Write-Log "Starting ADCS deployment..."
    Set-DeploymentState -Component "ADCS" -Status "InProgress" -Message "Starting deployment"
    
    $adcsScript = Join-Path $PSScriptRoot "setup-adcs.ps1"
    if (-not (Test-Path $adcsScript)) {
        Write-Log "ADCS setup script not found at: $adcsScript" -Level Error
        Set-DeploymentState -Component "ADCS" -Status "Failed" -Message "Setup script not found"
        return $false
    }
    
    try {
        $params = @{
            DomainName = $DomainName
            CACommonName = $CACommonName
        }
        
        if ($Debug) {
            $params.Add("Debug", $true)
        }
        
        $scriptBlock = [ScriptBlock]::Create("& '$adcsScript' " + 
            ($params.GetEnumerator() | ForEach-Object { "-$($_.Key) '$($_.Value)'" }) -join " ")
        
        Write-Log "Executing ADCS setup with parameters: $($params | ConvertTo-Json -Compress)" -Level Debug
        
        # Start execution with proper error handling
        $output = Invoke-Command -ScriptBlock $scriptBlock -ErrorVariable adcsError
        
        if ($adcsError) {
            Write-Log "ADCS setup failed with error: $adcsError" -Level Error
            Set-DeploymentState -Component "ADCS" -Status "Failed" -Message "Setup script error: $adcsError"
            return $false
        }
        
        Write-Log "ADCS deployment completed successfully"
        Set-DeploymentState -Component "ADCS" -Status "Completed" -Message "Deployment successful" -AdditionalData @{
            CAName = $CACommonName
            InstallDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        }
        return $true
    }
    catch {
        Write-Log "Error during ADCS deployment: $_" -Level Error
        Set-DeploymentState -Component "ADCS" -Status "Failed" -Message "Error: $_"
        return $false
    }
}

function Deploy-LegacyApp {
    $legacyAppState = Get-DeploymentState -Component "LegacyApp"
    
    # Check if Legacy App is already deployed and force is not specified
    if ($legacyAppState -and $legacyAppState.Status -eq "Completed" -and -not $Force) {
        Write-Log "Legacy App is already deployed. Use -Force to redeploy." -Level Warning
        return $true
    }
    
    Write-Log "Starting Legacy App deployment..."
    Set-DeploymentState -Component "LegacyApp" -Status "InProgress" -Message "Starting deployment"
    
    $legacyAppScript = Join-Path $PSScriptRoot "setup-legacy-app.ps1"
    if (-not (Test-Path $legacyAppScript)) {
        Write-Log "Legacy App setup script not found at: $legacyAppScript" -Level Error
        Set-DeploymentState -Component "LegacyApp" -Status "Failed" -Message "Setup script not found"
        return $false
    }
    
    try {
        $params = @{
            DomainName = $DomainName
        }
        
        if ($Debug) {
            $params.Add("Debug", $true)
        }
        
        $scriptBlock = [ScriptBlock]::Create("& '$legacyAppScript' " + 
            ($params.GetEnumerator() | ForEach-Object { "-$($_.Key) '$($_.Value)'" }) -join " ")
        
        Write-Log "Executing Legacy App setup with parameters: $($params | ConvertTo-Json -Compress)" -Level Debug
        
        # Start execution with proper error handling
        $output = Invoke-Command -ScriptBlock $scriptBlock -ErrorVariable legacyAppError
        
        if ($legacyAppError) {
            Write-Log "Legacy App setup failed with error: $legacyAppError" -Level Error
            Set-DeploymentState -Component "LegacyApp" -Status "Failed" -Message "Setup script error: $legacyAppError"
            return $false
        }
        
        Write-Log "Legacy App deployment completed successfully"
        Set-DeploymentState -Component "LegacyApp" -Status "Completed" -Message "Deployment successful" -AdditionalData @{
            AppUrl = "https://$env:COMPUTERNAME.$DomainName/LegacyApp"
            InstallDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        }
        return $true
    }
    catch {
        Write-Log "Error during Legacy App deployment: $_" -Level Error
        Set-DeploymentState -Component "LegacyApp" -Status "Failed" -Message "Error: $_"
        return $false
    }
}

function Configure-Certificates {
    $certState = Get-DeploymentState -Component "Certificates"
    
    # Check if certificates are already configured and force is not specified
    if ($certState -and $certState.Status -eq "Completed" -and -not $Force) {
        Write-Log "Certificates are already configured. Use -Force to reconfigure." -Level Warning
        return $true
    }
    
    Write-Log "Configuring certificates for deployed services..."
    Set-DeploymentState -Component "Certificates" -Status "InProgress" -Message "Starting configuration"
    
    $certScript = "C:\Scripts\Configure-Certificates.ps1"
    if (-not (Test-Path $certScript)) {
        Write-Log "Certificate configuration script not found at: $certScript" -Level Warning
        Set-DeploymentState -Component "Certificates" -Status "Skipped" -Message "Configuration script not found"
        return $false
    }
    
    try {
        & $certScript -ErrorAction Stop
        Write-Log "Certificate configuration completed successfully"
        Set-DeploymentState -Component "Certificates" -Status "Completed" -Message "Configuration successful" -AdditionalData @{
            ConfigDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        }
        return $true
    }
    catch {
        Write-Log "Error during certificate configuration: $_" -Level Error
        Set-DeploymentState -Component "Certificates" -Status "Failed" -Message "Error: $_"
        return $false
    }
}

function Test-Deployment {
    Write-Log "Running smoke tests for deployed services..."
    $testResults = @{}
    
    # Test ADCS
    if (-not $SkipADCS) {
        try {
            Write-Log "Testing ADCS..." -Level Debug
            $caTestResult = certutil -ping
            if ($caTestResult -match "Certificate Authority Ping Successful") {
                Write-Log "ADCS test: Passed" -Level Debug
                $testResults["ADCS"] = "Passed"
            } else {
                Write-Log "ADCS test: Failed - CA not responding" -Level Warning
                $testResults["ADCS"] = "Failed"
            }
        } catch {
            Write-Log "ADCS test: Error - $_" -Level Error
            $testResults["ADCS"] = "Error"
        }
    }
    
    # Test Legacy App
    if (-not $SkipLegacyApp) {
        try {
            Write-Log "Testing Legacy App..." -Level Debug
            $appUrl = "https://$env:COMPUTERNAME.$DomainName/LegacyApp"
            $webRequest = [System.Net.WebRequest]::Create($appUrl)
            $webRequest.Method = "HEAD"
            $webRequest.UseDefaultCredentials = $true
            
            try {
                $response = $webRequest.GetResponse()
                $statusCode = [int]$response.StatusCode
                $response.Close()
                
                if ($statusCode -eq 200) {
                    Write-Log "Legacy App test: Passed (Status: $statusCode)" -Level Debug
                    $testResults["LegacyApp"] = "Passed"
                } else {
                    Write-Log "Legacy App test: Failed (Status: $statusCode)" -Level Warning
                    $testResults["LegacyApp"] = "Failed"
                }
            } catch [System.Net.WebException] {
                $statusCode = [int]$_.Exception.Response.StatusCode
                Write-Log "Legacy App test: Failed (Status: $statusCode)" -Level Warning
                $testResults["LegacyApp"] = "Failed"
            }
        } catch {
            Write-Log "Legacy App test: Error - $_" -Level Error
            $testResults["LegacyApp"] = "Error"
        }
    }
    
    # Save test results to state file
    Set-DeploymentState -Component "SmokeTests" -Status "Completed" -Message "Tests completed" -AdditionalData $testResults
    
    return $testResults
}

# Main execution flow
Write-Log "Starting service deployment for domain: $DomainName"
Set-DeploymentState -Component "Deployment" -Status "InProgress" -Message "Starting deployment" -AdditionalData @{
    DomainName = $DomainName
    StartTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
}

if (-not (Test-Prerequisites)) {
    Write-Log "Prerequisites check failed. Exiting." -Level Error
    Set-DeploymentState -Component "Deployment" -Status "Failed" -Message "Prerequisites check failed"
    exit 1
}

$deploymentSuccess = $true

if (-not $SkipADCS) {
    if (-not (Deploy-ADCS)) {
        $deploymentSuccess = $false
        Write-Log "ADCS deployment failed" -Level Error
    }
}

if (-not $SkipLegacyApp) {
    if (-not (Deploy-LegacyApp)) {
        $deploymentSuccess = $false
        Write-Log "Legacy App deployment failed" -Level Error
    }
}

if ($deploymentSuccess) {
    Write-Log "Waiting for certificate services to be ready..."
    Write-Log "Sleeping for 60 seconds to allow services to initialize..." -Level Debug
    Start-Sleep -Seconds 60
    
    if (-not (Configure-Certificates)) {
        Write-Log "Certificate configuration failed" -Level Warning
    }
    
    $testResults = Test-Deployment
    
    $allTestsPassed = $true
    foreach ($test in $testResults.GetEnumerator()) {
        if ($test.Value -ne "Passed") {
            $allTestsPassed = $false
            break
        }
    }
    
    if ($allTestsPassed) {
        Set-DeploymentState -Component "Deployment" -Status "Completed" -Message "Deployment successful" -AdditionalData @{
            EndTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            TestResults = $testResults
        }
    } else {
        Set-DeploymentState -Component "Deployment" -Status "CompletedWithWarnings" -Message "Deployment completed but some tests failed" -AdditionalData @{
            EndTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            TestResults = $testResults
        }
    }
    
    Write-Log "Service deployment completed successfully"
    Write-Log @"
Deployment Summary:
------------------
Domain: $DomainName
CA Name: $CACommonName
ADCS Status: $(if(-not $SkipADCS) { if($testResults["ADCS"] -eq "Passed") { "Deployed and Verified" } else { "Deployed but Verification Failed" } } else { "Skipped" })
Legacy App Status: $(if(-not $SkipLegacyApp) { if($testResults["LegacyApp"] -eq "Passed") { "Deployed and Verified" } else { "Deployed but Verification Failed" } } else { "Skipped" })

Next Steps:
1. Verify ADCS is operational: certutil -ping
2. Check Legacy App: https://$(hostname).$DomainName/LegacyApp
3. Review logs at: $LogPath
4. View deployment state: Get-Content $StateFilePath | ConvertFrom-Json
"@
} else {
    Set-DeploymentState -Component "Deployment" -Status "Failed" -Message "Deployment failed"
    Write-Log "Service deployment completed with errors. Please review the logs." -Level Error
    exit 1
} 