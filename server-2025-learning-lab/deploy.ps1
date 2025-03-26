# Windows Server 2025 Learning Lab
# Deployment Script

param(
    [Parameter(Mandatory=$false)]
    [string]$Location = "eastus",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "",
    
    [Parameter(Mandatory=$false)]
    [string]$DomainName = "winlab2025",
    
    [Parameter(Mandatory=$false)]
    [string]$AdminUsername,
    
    [Parameter(Mandatory=$false)]
    [SecureString]$AdminPassword,
    
    [Parameter(Mandatory=$false)]
    [switch]$DeployDC2,
    
    [Parameter(Mandatory=$false)]
    [switch]$DeployLogAnalytics = $true,
    
    [Parameter(Mandatory=$false)]
    [switch]$Force,
    
    [Parameter(Mandatory=$false)]
    [string]$DeploymentStatePath = "$PSScriptRoot\deployment-state.json",
    
    [Parameter(Mandatory=$false)]
    [switch]$EnableVerbose
)

# Set debug preference based on parameter
if ($EnableVerbose) {
    $DebugPreference = "Continue"
    $VerbosePreference = "Continue"
}

# Banner
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "          Windows Server 2025 Learning Lab Deployer         " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Function to track deployment state
function Save-DeploymentState {
    param (
        [string]$Stage,
        [bool]$Completed,
        [string]$Message = ""
    )
    
    try {
        # Create or load existing state
        if (Test-Path $DeploymentStatePath) {
            $state = Get-Content $DeploymentStatePath -Raw | ConvertFrom-Json -ErrorAction Stop
            
            # Initialize properly if file exists but is invalid
            if (-not $state) {
                $state = [PSCustomObject]@{
                    LastRun = $null
                    Stages = [PSCustomObject]@{}
                    Resources = [PSCustomObject]@{}
                }
            }
            
            # Ensure Stages property exists
            if (-not (Get-Member -InputObject $state -Name "Stages" -MemberType Properties)) {
                Add-Member -InputObject $state -MemberType NoteProperty -Name "Stages" -Value ([PSCustomObject]@{})
            }
            
            # Ensure Resources property exists
            if (-not (Get-Member -InputObject $state -Name "Resources" -MemberType Properties)) {
                Add-Member -InputObject $state -MemberType NoteProperty -Name "Resources" -Value ([PSCustomObject]@{})
            }
        } else {
            $state = [PSCustomObject]@{
                LastRun = $null
                Stages = [PSCustomObject]@{}
                Resources = [PSCustomObject]@{}
            }
        }
        
        # Update state
        $state.LastRun = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        # Create or update stage
        $stageInfo = [PSCustomObject]@{
            Completed = $Completed
            CompletedAt = if ($Completed) { Get-Date -Format "yyyy-MM-dd HH:mm:ss" } else { $null }
            Message = $Message
        }
        
        if (Get-Member -InputObject $state.Stages -Name $Stage -MemberType Properties) {
            $state.Stages.$Stage = $stageInfo
        } else {
            Add-Member -InputObject $state.Stages -MemberType NoteProperty -Name $Stage -Value $stageInfo
        }
        
        # Ensure directory exists
        $stateDir = Split-Path $DeploymentStatePath -Parent
        if (-not (Test-Path $stateDir)) {
            New-Item -ItemType Directory -Path $stateDir -Force | Out-Null
        }
        
        # Save state to file with proper depth
        $json = ConvertTo-Json -InputObject $state -Depth 10 -Compress
        Set-Content -Path $DeploymentStatePath -Value $json
        
        Write-Debug "Deployment state updated: Stage '$Stage' - Completed: $Completed"
        return $true
    } catch {
        Write-Host "Warning: Failed to save deployment state: $_" -ForegroundColor Yellow
        Write-Debug "Stack trace: $($_.ScriptStackTrace)"
        # Continue with deployment even if state tracking fails
        return $false
    }
}

# Check if user is logged in to Azure
$context = Get-AzContext -ErrorAction SilentlyContinue
if (-not $context) {
    Write-Host "You are not logged in to Azure. Connecting..." -ForegroundColor Yellow
    Connect-AzAccount
} else {
    Write-Host "Connected to Azure as: $($context.Account)" -ForegroundColor Green
    Write-Host "Subscription: $($context.Subscription.Name)" -ForegroundColor Green
}

# Use subscription ID for unique prefix if resource group name not provided
if ([string]::IsNullOrEmpty($ResourceGroupName)) {
    $prefix = "ws2025${uniqueString(subscription().id)}"
    $ResourceGroupName = "${prefix}-rg"
}

# Ask for admin username if not provided
if (-not $AdminUsername) {
    $AdminUsername = Read-Host "Enter admin username (must be complex and 8+ characters)"
    while ($AdminUsername.Length -lt 8) {
        Write-Host "Username must be at least 8 characters long." -ForegroundColor Red
        $AdminUsername = Read-Host "Enter admin username (must be complex and 8+ characters)"
    }
}

# Generate random password if not provided
if (-not $AdminPassword) {
    $generateRandom = Read-Host "Would you like to generate a random password? (Y/N)"
    if ($generateRandom -eq "Y") {
        # Generate a complex random password
        $passwordLength = 16
        $alphabets = "abcdefghijklmnopqrstuvwxyz"
        $upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        $numbers = "0123456789"
        $special = "!@#$%^&*()_+-=[]{}|;':,./<>?"
        
        $password = ""
        $password += ($alphabets | Get-Random) # at least one lowercase
        $password += ($upperCase | Get-Random) # at least one uppercase
        $password += ($numbers | Get-Random) # at least one number
        $password += ($special | Get-Random) # at least one special char
        
        # Fill the rest randomly
        $allChars = $alphabets + $upperCase + $numbers + $special
        $remainingLength = $passwordLength - 4
        for ($i = 0; $i -lt $remainingLength; $i++) {
            $password += ($allChars | Get-Random)
        }
        
        # Shuffle the password
        $passwordArray = $password.ToCharArray()
        $shuffledArray = $passwordArray | Get-Random -Count $passwordArray.Length
        $password = -join $shuffledArray
        
        $AdminPassword = ConvertTo-SecureString $password -AsPlainText -Force
        Write-Host "Generated password: $password" -ForegroundColor Green
        Write-Host "*** Please save this password securely! ***" -ForegroundColor Yellow
    } else {
        # Ask for password
        $AdminPassword = Read-Host -AsSecureString "Enter admin password (must be complex and 12+ characters)"
    }
}

# Prompt for Azure region
$regions = @(
    "eastus", "eastus2", "southcentralus", "westus2", "westus3",
    "australiaeast", "southeastasia", "northeurope", "swedencentral", 
    "uksouth", "westeurope", "centralus", "southafricanorth", 
    "centralindia", "eastasia", "japaneast", "koreacentral", 
    "canadacentral", "francecentral", "germanywestcentral", 
    "italynorth", "norwayeast", "polandcentral", "switzerlandnorth", 
    "uaenorth", "brazilsouth", "qatarcentral"
)

$selectedRegion = Read-Host "Enter Azure region (press Enter for default: $Location)"
if ($selectedRegion -and $regions -contains $selectedRegion) {
    $Location = $selectedRegion
}

# Check for existing deployment
$deploymentExists = $false
if (Test-Path $DeploymentStatePath) {
    $existingState = Get-Content $DeploymentStatePath | ConvertFrom-Json
    if ($existingState.Stages.Infrastructure.Completed) {
        $deploymentExists = $true
        Write-Host "Existing deployment detected from $($existingState.LastRun)" -ForegroundColor Yellow
        
        if (-not $Force) {
            $continueDeployment = Read-Host "Do you want to continue with the existing deployment? (Y/N)"
            if ($continueDeployment -ne "Y") {
                $overwrite = Read-Host "Do you want to overwrite the existing deployment? (Y/N)"
                if ($overwrite -ne "Y") {
                    Write-Host "Deployment cancelled." -ForegroundColor Yellow
                    exit
                }
                # Clear deployment state
                Remove-Item $DeploymentStatePath -Force
                $deploymentExists = $false
            }
        }
    }
}

# Confirm deployment
Write-Host ""
Write-Host "Deployment Configuration:" -ForegroundColor Cyan
Write-Host "------------------------" -ForegroundColor Cyan
Write-Host "Region: $Location" -ForegroundColor White
Write-Host "Domain Name: $DomainName" -ForegroundColor White
Write-Host "Admin Username: $AdminUsername" -ForegroundColor White
Write-Host "Secondary DC: $(if($DeployDC2.IsPresent){'Yes'}else{'No'})" -ForegroundColor White
Write-Host "Log Analytics: $(if($DeployLogAnalytics.IsPresent){'Yes'}else{'No'})" -ForegroundColor White
if ($deploymentExists) {
    Write-Host "Mode: Continuing existing deployment" -ForegroundColor White
} else {
    Write-Host "Mode: New deployment" -ForegroundColor White
}
Write-Host ""

$confirmation = Read-Host "Ready to deploy Windows Server 2025 Learning Lab? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Deployment cancelled." -ForegroundColor Yellow
    exit
}

# Set current directory as the bicep working directory
$workingDirectory = $PSScriptRoot

# Check if there's an Azure subscription available
try {
    $subscriptions = Get-AzSubscription
    if (-not $subscriptions) {
        Write-Host "No Azure subscriptions found. Please create one or check your login credentials." -ForegroundColor Red
        exit
    }
} catch {
    Write-Host "Error checking subscriptions: $_" -ForegroundColor Red
    Save-DeploymentState -Stage "Prerequisites" -Completed $false -Message "Error checking subscriptions: $_"
    exit
}

Save-DeploymentState -Stage "Prerequisites" -Completed $true

# Deploy bicep template
Write-Host "Starting deployment..." -ForegroundColor Cyan
Save-DeploymentState -Stage "Infrastructure" -Completed $false -Message "Starting infrastructure deployment"

try {
    # Convert SecureString password to plain text for parameter
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminPassword)
    $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    
    # Create deployment name with timestamp
    $deploymentName = "WinServer2025Lab-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    
    # Deploy using Azure CLI
    Write-Host "Deploying Bicep template..." -ForegroundColor Yellow
    Write-Debug "Executing: az deployment sub create --name $deploymentName --location $Location --template-file $workingDirectory\bicep\main.bicep"
    
    # Debug output for parameters
    Write-Debug "Parameter values:"
    Write-Debug "- deployDC2 = $(if ($DeployDC2.IsPresent) { "true" } else { "false" })"
    Write-Debug "- deployLogAnalytics = $(if ($DeployLogAnalytics.IsPresent) { "true" } else { "false" })"
    
    $deploymentResult = az deployment sub create `
        --name $deploymentName `
        --location $Location `
        --template-file "$workingDirectory\bicep\main.bicep" `
        --parameters location=$Location `
        --parameters domainName=$DomainName `
        --parameters adminUsername=$AdminUsername `
        --parameters adminPassword=$plainPassword `
        --parameters resourceGroupName=$ResourceGroupName `
        --parameters deployDC2=$(if ($DeployDC2.IsPresent) { "true" } else { "false" }) `
        --parameters deployLogAnalytics=$(if ($DeployLogAnalytics.IsPresent) { "true" } else { "false" }) `
        --output json
    
    # Clean up the plain text password
    $plainPassword = "XXXXXXXX"
    
    # Parse the deployment outputs safely
    try {
        if ($deploymentResult) {
            $outputObj = $deploymentResult | ConvertFrom-Json -ErrorAction Stop
            
            # Get state from file or create new
            if (Test-Path $DeploymentStatePath) {
                $state = Get-Content $DeploymentStatePath -Raw | ConvertFrom-Json -ErrorAction Stop
            } else {
                $state = [PSCustomObject]@{
                    LastRun = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                    Stages = [PSCustomObject]@{}
                    Resources = [PSCustomObject]@{}
                }
            }
            
            # Ensure Resources property exists
            if (-not (Get-Member -InputObject $state -Name "Resources" -MemberType Properties)) {
                Add-Member -InputObject $state -MemberType NoteProperty -Name "Resources" -Value ([PSCustomObject]@{})
            }
            
            # Store each output as a property
            if ($outputObj.properties.outputs) {
                foreach ($output in $outputObj.properties.outputs.PSObject.Properties) {
                    $outputName = $output.Name
                    $outputValue = $output.Value.value
                    
                    if (Get-Member -InputObject $state.Resources -Name $outputName -MemberType Properties) {
                        $state.Resources.$outputName = $outputValue
                    } else {
                        Add-Member -InputObject $state.Resources -MemberType NoteProperty -Name $outputName -Value $outputValue
                    }
                }
            }
            
            # Save state to file
            $state | ConvertTo-Json -Depth 10 -Compress | Set-Content -Path $DeploymentStatePath
            Write-Debug "Deployment outputs saved to state file"
        } else {
            Write-Host "Warning: No deployment result returned. State file not updated." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Warning: Failed to save deployment outputs: $_" -ForegroundColor Yellow
        Write-Debug "Stack trace: $($_.ScriptStackTrace)"
        # Continue even if output parsing fails
    }
    
    Save-DeploymentState -Stage "Infrastructure" -Completed $true -Message "Infrastructure deployment completed successfully"
    
} catch {
    Write-Host "Error during deployment: $_" -ForegroundColor Red
    Write-Debug "Deployment failed with exception: $_"
    Save-DeploymentState -Stage "Infrastructure" -Completed $false -Message "Error during deployment: $_"
    exit 1
}

Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Access Information:" -ForegroundColor Cyan
Write-Host "-----------------" -ForegroundColor Cyan
Write-Host "1. Deploy outputs contain connection information." -ForegroundColor White
Write-Host "2. Use Azure Bastion to connect to your VMs." -ForegroundColor White
Write-Host "3. Your credentials are stored in the created Key Vault." -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "-----------" -ForegroundColor Cyan
Write-Host "1. Allow 30-45 minutes for Active Directory to complete setup" -ForegroundColor White
Write-Host "2. Connect to dc1 via Bastion to verify AD setup is complete" -ForegroundColor White
Write-Host "3. Connect to mem1 via Bastion to deploy ADCS" -ForegroundColor White
Write-Host "4. On mem1, run: " -ForegroundColor White -NoNewline
Write-Host ".\deploy-services.ps1 -DomainName $DomainName -SkipLegacyApp" -ForegroundColor Yellow
Write-Host "5. Test ADCS functionality with: " -ForegroundColor White -NoNewline
Write-Host "certutil -ping" -ForegroundColor Yellow
Write-Host ""
Write-Host "Lab Resources:" -ForegroundColor Cyan
Write-Host "-------------" -ForegroundColor Cyan
Write-Host "- Domain Controller (dc1): Primary DC and DNS" -ForegroundColor White
if ($DeployDC2.IsPresent) {
    Write-Host "- Domain Controller (dc2): Secondary DC" -ForegroundColor White
}
Write-Host "- Member Server (mem1): ADCS and administrative tools" -ForegroundColor White
Write-Host "- Domain: $DomainName" -ForegroundColor White
Write-Host "- Resource Group: $ResourceGroupName" -ForegroundColor White
if ($DeployLogAnalytics.IsPresent) {
    Write-Host "- Log Analytics: Centralized monitoring and logging" -ForegroundColor White
}
Write-Host ""
Write-Host "For troubleshooting:" -ForegroundColor Cyan
Write-Host "- Check deployment logs in the Azure portal" -ForegroundColor White
Write-Host "- Review VM setup logs at C:\Logs on each server" -ForegroundColor White
Write-Host "- ADCS deployment logs are at C:\Logs\ADCS-Setup.log" -ForegroundColor White
Write-Host ""
Write-Host "Deployment state saved at: $DeploymentStatePath" -ForegroundColor White
Write-Host ""
Write-Host "Enjoy your Windows Server 2025 Learning Lab!" -ForegroundColor Green 