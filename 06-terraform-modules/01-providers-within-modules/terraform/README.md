# Terraform Demo: Providers within Modules

This directory contains two demo setups that demonstrate the difference between the wrong and right way to handle providers within Terraform modules.

## Prerequisites

- AWS CloudShell or local environment with AWS CLI configured
- Terraform installed (version 1.0 or later)
- Basic understanding of Terraform concepts

## Demo Structure

```
terraform/
├── demo-wrong-way/          # Shows the problematic approach
│   ├── main.tf              # Root configuration
│   ├── versions.tf          # Terraform and provider versions
│   └── modules/
│       └── s3-bucket/       # Module with embedded provider
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
├── demo-right-way/          # Shows the recommended approach
│   ├── main.tf              # Root configuration with provider
│   ├── versions.tf          # Terraform and provider versions
│   └── modules/
│       └── s3-bucket/       # Provider-agnostic module
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── README.md                # This file
```

## Quick Start

### Option 1: Demo the Wrong Way (Don't do this in production!)

```bash
cd demo-wrong-way
terraform init
terraform plan
terraform apply

# Step-by-step experiment to see the problem:
# 1. Comment out the module block in main.tf
# 2. Try 'terraform plan' - you'll get "Reference to undeclared module" errors
# 3. Comment out the output blocks too
# 4. Try 'terraform plan' again - now you'll see the provider configuration problem!
```

### Option 2: Demo the Right Way (Recommended approach)

```bash
cd demo-right-way
terraform init
terraform plan
terraform apply
# Remove modules safely without losing provider configurations
```

**📖 For detailed step-by-step instructions and AWS CloudShell setup, see [CLOUDSHELL_INSTRUCTIONS.md](./CLOUDSHELL_INSTRUCTIONS.md)**

## What You'll Learn

1. **Wrong Way Issues**: How provider configs inside modules cause problems during cleanup
2. **Common Gotchas**: The "Reference to undeclared module" error and how to work through it
3. **Right Way Benefits**: How centralized providers make modules more flexible and maintainable
4. **Practical Experience**: Hands-on experience with both approaches using simple S3 bucket examples

## Clean Up

Don't forget to destroy resources after testing:

```bash
terraform destroy
```

**Note**: If you run into issues destroying resources in the "wrong way" demo after removing modules, this demonstrates the exact problem this guide addresses!
