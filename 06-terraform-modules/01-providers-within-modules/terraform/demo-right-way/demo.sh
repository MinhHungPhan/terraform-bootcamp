#!/bin/bash

# Demo Script: The Right Way
# This script demonstrates the recommended approach

echo "=== Terraform Demo: The Right Way (Provider in Root) ==="
echo ""
echo "This demo shows the recommended approach with providers in root configuration."
echo "You'll see how easy it is to manage modules when providers are centralized."
echo ""

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "Error: Please run this script from the demo-right-way directory"
    exit 1
fi

echo "Step 1: Initialize Terraform"
terraform init

echo ""
echo "Step 2: Plan the deployment"
terraform plan

echo ""
echo "Step 3: Apply the configuration (creating S3 buckets in multiple regions)"
read -p "Do you want to continue with terraform apply? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    terraform apply
    
    echo ""
    echo "✅ Resources created successfully!"
    echo ""
    echo "Notice how the same module was used to create buckets in different regions!"
    echo "This is possible because:"
    echo "1. Provider configurations are in the root (main.tf)"
    echo "2. Different provider aliases are passed to each module instance"
    echo "3. Modules are provider-agnostic and flexible"
    echo ""
    echo "Try this experiment:"
    echo "1. Comment out one of the module blocks in main.tf"
    echo "2. Run 'terraform plan' and 'terraform apply'"
    echo "3. Notice how it destroys cleanly because provider configs remain!"
    echo ""
    echo "To clean up: run 'terraform destroy'"
else
    echo "Demo cancelled. Run 'terraform apply' manually when ready."
fi
