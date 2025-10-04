# AWS CloudShell Demo Instructions

Follow these instructions to run the Terraform demo on AWS CloudShell.

## Prerequisites

1. **AWS CloudShell Access**: Log into your AWS Console and open CloudShell
2. **Basic AWS Permissions**: Ensure your user/role has permissions to create S3 buckets
3. **Terraform Installation**: Check if Terraform is installed, or install it

## Step 1: Setup in CloudShell

```bash
# Check if Terraform is installed
terraform version
```

If not installed, install Terraform using these following commands:

```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform
```

## Step 2: Demo the Wrong Way

### 2.1: Navigate and Initialize

```bash
# Navigate to the wrong way demo
cd terraform/demo-wrong-way
```

### 2.2: Run Initial Setup

```bash
# Initialize Terraform
terraform init
```

### 2.3: Deploy Resources

```bash
# Plan the deployment
terraform plan

# Apply the configuration
terraform apply -auto-approve
```

**✅ At this point, you should have an S3 bucket created successfully.**

### 2.4: Simulate Module Removal (Part 1)

Edit `main.tf` and comment out the module block:

```hcl
# module "demo_bucket" {
#   source      = "./modules/s3-bucket"
#   bucket_name = "demo-wrong-way-bucket"
#   environment = "demo"
# }
```

### 2.5: First Error - Reference to Undeclared Module

```bash
terraform plan
```

**❌ Expected Error:** You'll get "Reference to undeclared module" errors because the outputs still reference the commented module.

```js
│ Error: Reference to undeclared module
│
│   on main.tf line 20, in output "bucket_name":
│   20:   value       = module.demo_bucket.bucket_name
│
│ No module call named "demo_bucket" is declared in the root module.
╵
╷
│ Error: Reference to undeclared module
│
│   on main.tf line 25, in output "bucket_region":
│   25:   value       = module.demo_bucket.bucket_region
│
│ No module call named "demo_bucket" is declared in the root module.
```

### 2.6: Fix the Reference Error

Comment out the output blocks in `main.tf`:

```hcl
# output "bucket_name" {
#   description = "Name of the S3 bucket created"
#   value       = module.demo_bucket.bucket_name
# }

# output "bucket_region" {
#   description = "Region where the bucket was created" 
#   value       = module.demo_bucket.bucket_region
# }
```

### 2.7: See the Real Problem

```bash
# Now plan again
terraform plan
```

```bash
# Try to apply the changes
terraform apply -auto-approve
```

**🚨 This is the REAL problem:** Terraform knows the bucket exists (in state) but can't destroy it because the provider configuration disappeared with the module!

```js
Error: Provider configuration not present
│
│ To work with module.demo_bucket.aws_s3_bucket.main (orphan) its original provider configuration at
│ module.demo_bucket.provider["registry.terraform.io/hashicorp/aws"] is required, but it has been removed. This occurs when a provider
│ configuration is removed while objects created by that provider still exist in the state. Re-add the provider configuration to destroy
│ module.demo_bucket.aws_s3_bucket.main (orphan), after which you can remove the provider configuration again.
╵
╷
│ Error: Provider configuration not present
│
│ To work with module.demo_bucket.aws_s3_bucket_public_access_block.main (orphan) its original provider configuration at
│ module.demo_bucket.provider["registry.terraform.io/hashicorp/aws"] is required, but it has been removed. This occurs when a provider
│ configuration is removed while objects created by that provider still exist in the state. Re-add the provider configuration to destroy
│ module.demo_bucket.aws_s3_bucket_public_access_block.main (orphan), after which you can remove the provider configuration again.
╵
╷
│ Error: Provider configuration not present
│
│ To work with module.demo_bucket.aws_s3_bucket_versioning.main (orphan) its original provider configuration at
│ module.demo_bucket.provider["registry.terraform.io/hashicorp/aws"] is required, but it has been removed. This occurs when a provider
│ configuration is removed while objects created by that provider still exist in the state. Re-add the provider configuration to destroy
│ module.demo_bucket.aws_s3_bucket_versioning.main (orphan), after which you can remove the provider configuration again.
```

### 2.8: Recovery

```bash
# 1. Uncomment the module block AND outputs in main.tf
# 2. Then destroy properly
terraform destroy
```

## Step 3: Demo the Right Way

### 3.1: Navigate and Initialize

```bash
# Navigate to the right way demo
cd ../demo-right-way
```

### 3.2: Run Initial Setup

```bash
# Initialize Terraform
terraform init
```

### 3.3: Deploy Resources

```bash
# Plan the deployment
terraform plan

# Apply the configuration
terraform apply -auto-approve
```

**✅ At this point, you should have S3 buckets in both us-east-1 and us-west-2.**

### 3.4: Safely Remove a Module

Edit `main.tf` and comment out one module block:

```hcl
# module "bucket_west" {
#   source = "./modules/s3-bucket"
#   providers = {
#     aws = aws.west
#   }
#   bucket_name = "demo-right-way-bucket-west"
#   environment = "demo"
# }
```

### 3.5: Handle Output References

```bash
# Try to plan - you'll get "Reference to undeclared module" errors
terraform plan
```

**❌ Expected Error:** Just like in the wrong way demo, you'll get reference errors because outputs still reference the commented module.

```js
│ Error: Reference to undeclared module
│
│   on main.tf line 55, in output "bucket_west_name":
│   55:   value       = module.bucket_west.bucket_name
│
│ No module call named "bucket_west" is declared in the root module. Did you mean "bucket_east"?
╵
╷
│ Error: Reference to undeclared module
│
│   on main.tf line 60, in output "bucket_west_region":
│   60:   value       = module.bucket_west.bucket_region
│
│ No module call named "bucket_west" is declared in the root module. Did you mean "bucket_east"?
```

Also comment out the outputs that reference the west module:

```hcl
# output "bucket_west_name" {
#   description = "Name of the S3 bucket created in us-west-2"
#   value       = module.bucket_west.bucket_name
# }

# output "bucket_west_region" {
#   description = "Region of the western bucket"
#   value       = module.bucket_west.bucket_region
# }
```

### 3.6: Apply Changes Safely

```bash
# Plan the changes
terraform plan
```

```bash
# Apply the changes
terraform apply -auto-approve
```

**✅ Notice:** The western bucket destroys cleanly because the provider configuration remains in the root!

### 3.7: Clean Up Everything

```bash
# Destroy all remaining resources
terraform destroy -auto-approve
```

## What You'll Observe

### Wrong Way Issues:
- Provider configuration disappears with the module
- Difficult to destroy resources cleanly
- Hidden dependencies between modules and providers

### Right Way Benefits:
- Provider configurations remain centralized and visible
- Easy to remove modules without losing provider access
- Same module can be reused with different provider configurations
- Clean destruction of resources

## Key Learning Points

1. **Provider Ownership**: Keep providers in root configuration, not in modules
2. **Explicit Provider Passing**: Use the `providers = { aws = aws.alias }` syntax
3. **Module Flexibility**: Provider-agnostic modules are more reusable
4. **Clean Teardown**: Centralized providers enable safe resource cleanup

## Troubleshooting

### Permission Issues

If you get AWS permission errors:

```bash
# Check your AWS identity
aws sts get-caller-identity

# Ensure you have S3 permissions in your AWS policy
```

### Bucket Name Conflicts

S3 bucket names must be globally unique. The demo uses random suffixes to avoid conflicts, but if you still get naming errors:
- Change the `bucket_name` variable in the module calls
- Or wait a few minutes if you recently deleted buckets with similar names

### Provider Download Issues

If provider downloads fail in CloudShell:

```bash
# Clear Terraform cache and retry
rm -rf .terraform
terraform init
```

## Clean Up

Always clean up your resources when done:

```bash
# In each demo directory
terraform destroy

# Confirm all resources are deleted
aws s3 ls | grep demo-
```

Remember: The "wrong way" demo might leave orphaned resources if you follow the problematic steps. This is intentional to demonstrate the issue, but make sure to clean up properly afterward!
