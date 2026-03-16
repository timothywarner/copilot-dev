# Bicep Template Unit Tests
# These tests validate the correctness of the Bicep template configuration

#Requires -Version 7.0

# Test configuration
$BicepFilePath = Join-Path $PSScriptRoot ".." "infrastructure" "main.bicep"
$ErrorActionPreference = "Stop"

# Color output functions
function Write-TestSuccess {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-TestFailure {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-TestInfo {
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Cyan
}

# Test counter
$script:TestsPassed = 0
$script:TestsFailed = 0
$script:TestsTotal = 0

function Test-Assertion {
    param(
        [bool]$Condition,
        [string]$TestName,
        [string]$FailureMessage
    )
    
    $script:TestsTotal++
    
    if ($Condition) {
        Write-TestSuccess $TestName
        $script:TestsPassed++
        return $true
    } else {
        Write-TestFailure "$TestName - $FailureMessage"
        $script:TestsFailed++
        return $false
    }
}

# Test 1: Bicep file exists
function Test-BicepFileExists {
    Write-TestInfo "`nTest 1: Bicep file existence"
    
    $exists = Test-Path $BicepFilePath
    Test-Assertion -Condition $exists `
        -TestName "Bicep file exists at $BicepFilePath" `
        -FailureMessage "File not found"
}

# Test 2: Bicep file is not empty
function Test-BicepFileNotEmpty {
    Write-TestInfo "`nTest 2: Bicep file content"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        $notEmpty = $content.Length -gt 0
        Test-Assertion -Condition $notEmpty `
            -TestName "Bicep file is not empty" `
            -FailureMessage "File is empty"
    } else {
        Test-Assertion -Condition $false `
            -TestName "Bicep file is not empty" `
            -FailureMessage "File does not exist"
    }
}

# Test 3: Virtual network resource is defined
function Test-VirtualNetworkDefined {
    Write-TestInfo "`nTest 3: Virtual network resource definition"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        $hasVNet = $content -match "resource.*'Microsoft\.Network/virtualNetworks@"
        Test-Assertion -Condition $hasVNet `
            -TestName "Virtual network resource is defined" `
            -FailureMessage "Virtual network resource not found in template"
    } else {
        Test-Assertion -Condition $false `
            -TestName "Virtual network resource is defined" `
            -FailureMessage "File does not exist"
    }
}

# Test 4: VNet address space parameter exists
function Test-VNetAddressSpaceParameter {
    Write-TestInfo "`nTest 4: VNet address space parameter"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        $hasParam = $content -match "param\s+vnetAddressPrefix"
        Test-Assertion -Condition $hasParam `
            -TestName "VNet address space parameter is defined" `
            -FailureMessage "vnetAddressPrefix parameter not found"
    } else {
        Test-Assertion -Condition $false `
            -TestName "VNet address space parameter is defined" `
            -FailureMessage "File does not exist"
    }
}

# Test 5: Subnet address prefix parameter exists
function Test-SubnetAddressParameter {
    Write-TestInfo "`nTest 5: Subnet address prefix parameter"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        $hasParam = $content -match "param\s+subnetAddressPrefix"
        Test-Assertion -Condition $hasParam `
            -TestName "Subnet address prefix parameter is defined" `
            -FailureMessage "subnetAddressPrefix parameter not found"
    } else {
        Test-Assertion -Condition $false `
            -TestName "Subnet address prefix parameter is defined" `
            -FailureMessage "File does not exist"
    }
}

# Test 6: Default subnet prefix is within VNet address space
function Test-SubnetWithinVNetAddressSpace {
    Write-TestInfo "`nTest 6: Subnet address prefix validation"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        
        # Extract default values
        if ($content -match "param vnetAddressPrefix string = '([^']+)'") {
            $vnetPrefix = $Matches[1]
        }
        
        if ($content -match "param subnetAddressPrefix string = '([^']+)'") {
            $subnetPrefix = $Matches[1]
        }
        
        if ($vnetPrefix -and $subnetPrefix) {
            # Extract first two octets for basic validation
            $vnetBase = ($vnetPrefix -split '\.')[0..1] -join '.'
            $subnetBase = ($subnetPrefix -split '\.')[0..1] -join '.'
            
            $isValid = $vnetBase -eq $subnetBase
            Test-Assertion -Condition $isValid `
                -TestName "Subnet prefix ($subnetPrefix) is within VNet address space ($vnetPrefix)" `
                -FailureMessage "Subnet prefix appears to be outside VNet address space"
        } else {
            Test-Assertion -Condition $false `
                -TestName "Subnet prefix is within VNet address space" `
                -FailureMessage "Could not extract address prefixes from template"
        }
    } else {
        Test-Assertion -Condition $false `
            -TestName "Subnet prefix is within VNet address space" `
            -FailureMessage "File does not exist"
    }
}

# Test 7: Subnets array is defined in VNet properties
function Test-SubnetsArrayDefined {
    Write-TestInfo "`nTest 7: Subnets array definition"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        $hasSubnets = $content -match "subnets:\s*\["
        Test-Assertion -Condition $hasSubnets `
            -TestName "Subnets array is defined in virtual network properties" `
            -FailureMessage "Subnets array not found in VNet definition"
    } else {
        Test-Assertion -Condition $false `
            -TestName "Subnets array is defined" `
            -FailureMessage "File does not exist"
    }
}

# Test 8: Required outputs are defined
function Test-RequiredOutputs {
    Write-TestInfo "`nTest 8: Required outputs"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        
        $hasVNetId = $content -match "output\s+vnetId"
        $hasVNetName = $content -match "output\s+vnetName"
        $hasSubnetId = $content -match "output\s+subnetId"
        
        $allOutputs = $hasVNetId -and $hasVNetName -and $hasSubnetId
        
        Test-Assertion -Condition $allOutputs `
            -TestName "Required outputs (vnetId, vnetName, subnetId) are defined" `
            -FailureMessage "One or more required outputs are missing"
    } else {
        Test-Assertion -Condition $false `
            -TestName "Required outputs are defined" `
            -FailureMessage "File does not exist"
    }
}

# Test 9: Location parameter exists
function Test-LocationParameter {
    Write-TestInfo "`nTest 9: Location parameter"
    
    if (Test-Path $BicepFilePath) {
        $content = Get-Content $BicepFilePath -Raw
        $hasLocation = $content -match "param\s+location\s+string"
        Test-Assertion -Condition $hasLocation `
            -TestName "Location parameter is defined" `
            -FailureMessage "location parameter not found"
    } else {
        Test-Assertion -Condition $false `
            -TestName "Location parameter is defined" `
            -FailureMessage "File does not exist"
    }
}

# Test 10: Bicep syntax validation (if Azure CLI is available)
function Test-BicepSyntax {
    Write-TestInfo "`nTest 10: Bicep syntax validation"
    
    # Check if Azure CLI is installed
    $azInstalled = $null -ne (Get-Command az -ErrorAction SilentlyContinue)
    
    if (-not $azInstalled) {
        Write-TestInfo "  Skipping: Azure CLI not installed"
        return
    }
    
    if (Test-Path $BicepFilePath) {
        try {
            $output = az bicep build --file $BicepFilePath --stdout 2>&1
            $exitCode = $LASTEXITCODE
            
            $isValid = $exitCode -eq 0
            Test-Assertion -Condition $isValid `
                -TestName "Bicep syntax is valid (az bicep build)" `
                -FailureMessage "Bicep build failed with errors"
        }
        catch {
            Test-Assertion -Condition $false `
                -TestName "Bicep syntax is valid" `
                -FailureMessage "Error running bicep build: $_"
        }
    } else {
        Test-Assertion -Condition $false `
            -TestName "Bicep syntax is valid" `
            -FailureMessage "File does not exist"
    }
}

# Main test execution
function Invoke-BicepTests {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Bicep Template Unit Tests" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Testing file: $BicepFilePath`n" -ForegroundColor Cyan
    
    # Run all tests
    Test-BicepFileExists
    Test-BicepFileNotEmpty
    Test-VirtualNetworkDefined
    Test-VNetAddressSpaceParameter
    Test-SubnetAddressParameter
    Test-SubnetWithinVNetAddressSpace
    Test-SubnetsArrayDefined
    Test-RequiredOutputs
    Test-LocationParameter
    Test-BicepSyntax
    
    # Print summary
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Test Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Total Tests:  $script:TestsTotal" -ForegroundColor White
    Write-Host "Passed:       $script:TestsPassed" -ForegroundColor Green
    Write-Host "Failed:       $script:TestsFailed" -ForegroundColor $(if ($script:TestsFailed -gt 0) { "Red" } else { "Green" })
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    # Exit with appropriate code
    if ($script:TestsFailed -gt 0) {
        exit 1
    } else {
        Write-Host "All tests passed! ✓" -ForegroundColor Green
        exit 0
    }
}

# Run the tests
Invoke-BicepTests
