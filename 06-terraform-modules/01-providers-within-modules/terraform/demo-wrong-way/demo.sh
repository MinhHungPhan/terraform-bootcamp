#!/bin/bash

# Demo Script: The Wrong Way
# This script demonstrates the problematic approach

echo "=== Terraform Demo: The Wrong Way (Provider Inside Module) ==="
echo ""
echo "This demo shows what happens when providers are defined inside modules."
echo "You'll see the problem when you try to remove the module later."
echo ""

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "Error: Please run this script from the demo-wrong-way directory"
    exit 1
fi

echo "Step 1: Initialize Terraform"
terraform init

echo ""
echo "Step 2: Plan the deployment"
terraform plan

echo ""
echo "Step 3: Apply the configuration (creating S3 bucket)"
read -p "Do you want to continue with terraform apply? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    terraform apply
    
    echo ""
    echo "✅ Resources created successfully!"
    echo ""
    echo "Now try this experiment:"
    echo "1. Comment out or remove the 'module \"demo_bucket\"' block in main.tf"
    echo "2. Run 'terraform plan' - you'll see Terraform wants to destroy the bucket"
    echo "3. Run 'terraform apply' - you'll see the problem!"
    echo ""
    echo "The issue: When you remove the module, you also remove the provider"
    echo "configuration that Terraform needs to destroy the resources."
    echo ""
    echo "To clean up properly, uncomment the module and run 'terraform destroy'"
else
    echo "Demo cancelled. Run 'terraform apply' manually when ready."
fi
