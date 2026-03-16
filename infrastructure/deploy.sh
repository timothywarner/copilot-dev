#!/bin/bash

# Deployment script for Azure Bicep template
# This script includes validation checks to catch misconfigurations early

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
RESOURCE_GROUP_NAME="${RESOURCE_GROUP_NAME:-rg-copilot-dev}"
LOCATION="${LOCATION:-eastus}"
BICEP_FILE="./main.bicep"
DEPLOYMENT_NAME="vnet-deployment-$(date +%s)"

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "$1"
}

# Function to check if Azure CLI is installed
check_azure_cli() {
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install it first."
        exit 1
    fi
    print_success "Azure CLI is installed"
}

# Function to check if logged in to Azure
check_azure_login() {
    if ! az account show &> /dev/null; then
        print_error "Not logged in to Azure. Please run 'az login' first."
        exit 1
    fi
    print_success "Logged in to Azure"
}

# Function to validate Bicep file exists
check_bicep_file() {
    if [ ! -f "$BICEP_FILE" ]; then
        print_error "Bicep file not found: $BICEP_FILE"
        exit 1
    fi
    print_success "Bicep file found: $BICEP_FILE"
}

# Function to validate Bicep syntax
validate_bicep_syntax() {
    print_info "Validating Bicep syntax..."
    if az bicep build --file "$BICEP_FILE" --stdout > /dev/null 2>&1; then
        print_success "Bicep syntax is valid"
    else
        print_error "Bicep syntax validation failed"
        exit 1
    fi
}

# Function to validate virtual network configuration
validate_vnet_configuration() {
    print_info "Validating virtual network configuration..."
    
    # Extract parameters from Bicep file
    local vnet_prefix=$(grep "param vnetAddressPrefix string" "$BICEP_FILE" | grep -o "'[^']*'" | tr -d "'")
    local subnet_prefix=$(grep "param subnetAddressPrefix string" "$BICEP_FILE" | grep -o "'[^']*'" | tr -d "'")
    
    if [ -z "$vnet_prefix" ] || [ -z "$subnet_prefix" ]; then
        print_warning "Could not extract default address prefixes from Bicep file"
        print_warning "Validation will occur during deployment"
        return 0
    fi
    
    print_info "  VNet address space: $vnet_prefix"
    print_info "  Subnet address prefix: $subnet_prefix"
    
    # Basic validation: check if subnet prefix starts with VNet prefix base
    local vnet_base=$(echo "$vnet_prefix" | cut -d'.' -f1-2)
    local subnet_base=$(echo "$subnet_prefix" | cut -d'.' -f1-2)
    
    if [ "$vnet_base" != "$subnet_base" ]; then
        print_error "Subnet address prefix ($subnet_prefix) appears to be outside VNet address space ($vnet_prefix)"
        print_error "Please ensure subnet address prefix is within the virtual network address space"
        exit 1
    fi
    
    print_success "Virtual network configuration appears valid"
}

# Function to create resource group if it doesn't exist
create_resource_group() {
    print_info "Checking resource group: $RESOURCE_GROUP_NAME"
    
    if az group show --name "$RESOURCE_GROUP_NAME" &> /dev/null; then
        print_success "Resource group already exists: $RESOURCE_GROUP_NAME"
    else
        print_info "Creating resource group: $RESOURCE_GROUP_NAME in $LOCATION"
        if az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION" &> /dev/null; then
            print_success "Resource group created: $RESOURCE_GROUP_NAME"
        else
            print_error "Failed to create resource group"
            exit 1
        fi
    fi
}

# Function to validate deployment (what-if)
validate_deployment() {
    print_info "Running deployment validation (what-if)..."
    
    if az deployment group what-if \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --template-file "$BICEP_FILE" \
        --no-pretty-print &> /dev/null; then
        print_success "Deployment validation passed"
    else
        print_error "Deployment validation failed"
        print_info "Run the following command for details:"
        print_info "  az deployment group what-if --resource-group $RESOURCE_GROUP_NAME --template-file $BICEP_FILE"
        exit 1
    fi
}

# Function to deploy the Bicep template
deploy_template() {
    print_info "Deploying Bicep template: $DEPLOYMENT_NAME"
    
    if az deployment group create \
        --name "$DEPLOYMENT_NAME" \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --template-file "$BICEP_FILE" \
        --output json > deployment-output.json; then
        
        print_success "Deployment successful: $DEPLOYMENT_NAME"
        
        # Display outputs
        print_info "\nDeployment Outputs:"
        cat deployment-output.json | grep -A 20 '"outputs"' || true
        
        return 0
    else
        print_error "Deployment failed"
        return 1
    fi
}

# Main execution
main() {
    print_info "=========================================="
    print_info "Azure Bicep Deployment Script"
    print_info "=========================================="
    print_info ""
    
    # Run all validation checks
    check_azure_cli
    check_azure_login
    check_bicep_file
    validate_bicep_syntax
    validate_vnet_configuration
    
    print_info ""
    print_info "=========================================="
    print_info "Starting Deployment"
    print_info "=========================================="
    print_info ""
    
    create_resource_group
    validate_deployment
    deploy_template
    
    print_info ""
    print_success "=========================================="
    print_success "Deployment completed successfully!"
    print_success "=========================================="
}

# Run main function
main
