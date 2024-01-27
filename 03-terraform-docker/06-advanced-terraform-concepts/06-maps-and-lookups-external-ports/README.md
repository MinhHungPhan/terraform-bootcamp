# Maps and Lookups - External Ports

Welcome to the README for Maps and Lookups: External Ports. In this document, we will explore how to manage external ports for different environments effectively. Whether you're a beginner or an experienced user, this guide will help you understand and utilize external port mapping in your Terraform projects.

## Table of Contents

- [Introduction](#introduction)
- [Concepts](#concepts)
- [Hands-On Lab](#hands-on-lab)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

In any infrastructure deployment, it's crucial to manage external ports efficiently. Whether you're deploying applications in a development (dev) or production (prod) environment, conflicts and security issues can arise if ports are not properly assigned. This guide aims to help you understand how to map and manage external ports using Terraform for different environments.

### Purpose and Target Audience

**Purpose:** The purpose of this document is to provide a clear and practical guide for managing external ports in Terraform. We will cover essential concepts, usage examples, best practices, and hands-on labs to ensure you can confidently manage external ports for your infrastructure.

**Target Audience:** This document is intended for beginners and experienced Terraform users who want to learn how to set up and manage external ports effectively. Whether you're a developer, DevOps engineer, or a system administrator, this guide is designed to help you.

## Concepts

Before we dive into practical examples, let's understand some key concepts related to external ports and their management:

- **Maps:** In Terraform, maps are data structures that allow you to associate keys with values. In this guide, we'll use maps to define the external ports for different environments (dev and prod).

- **Lookups:** Terraform's `lookup` function allows you to retrieve values from maps based on specified keys. We will use `lookup` to select the appropriate external port for a given environment.

## Hands-On Lab

In this hands-on lab, we will demonstrate how to configure and use external ports for your Terraform project. Follow these steps:

### Step 1: Clean the Current State

First, ensure your current Terraform state is clean and free from previous configurations. This step is crucial for a fresh start.

Run:

```bash
terraform destroy --auto-approve
```

### Step 2: Define External Ports in `terraform.tfvars`

Edit your `terraform.tfvars` file to define the external ports for both development (dev) and production (prod) environments. 

```hcl
ext_port = {
   dev = [1980,1981]
   prod = [1880,1881]
}
```

### Step 3: Update Variable Type in Variable Block

Change the external port variable in the variable block to a map type to accommodate different values for different environments.

```hcl
variable "ext_port" {
  type = map
  # Additional configurations and validations can be added here
}
```

### Step 4: Update Local Values for Port Lookup

Modify the `locals` block in your Terraform configuration to use the `lookup` function. This function retrieves the correct ports based on the specified environment.

```hcl
locals {
  container_count = length(lookup(var.ext_port, var.env))
}
```

### Step 5: Configure Main.tf for External Ports

In your `main.tf` file, set up the resource configuration to use the lookup for external ports.

```hcl
resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = var.int_port
    external = lookup(var.ext_port, var.env)[count.index]
  }
  # Additional resource configurations go here
}
```

### Step 6: Run Terraform Plan and Check Outputs

Execute `terraform plan` and use `grep` to filter the output for external ports. This will validate if the configurations are picked up correctly.

Run for dev environment:

```bash
terraform plan | grep external
```

Expected output for dev environment:

```
+ external = 1980
+ external = 1981
```

Run for prod environment:

```bash
terraform plan -var="env=prod" | grep external
```

Expected output for prod environment:

```
+ external = 1880
+ external = 1881
```

### Step 7: Implement and Test Validation Rules

Add validation rules in the variable block to ensure that the ports are within the valid range for each environment.

```hcl
variable "ext_port" {
  type = map

  validation {
    condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
    error_message = "The external port for dev must be in the range 1980 - 65535."
  }

  validation {
    condition     = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
    error_message = "The external port for prod must be in the range 1880 - 1979."
  }
}
```

Test the validation by modifying the `ext_port` values in `terraform.tfvars` and rerun `terraform plan`. Ensure it fails when an invalid port is specified.

### Step 8: Testing the Validation Rules

After setting up the validation rules for the external ports in your Terraform configuration, it's important to test them to ensure they work as expected. This involves intentionally setting invalid port values in `terraform.tfvars` and running `terraform plan` to confirm that the validation rules catch these errors.

#### Testing for Dev Environment

1. **Modify `terraform.tfvars` for Dev Environment:**

Change the external ports for the dev environment to values that are outside the valid range. For instance, set a port number higher than 65535 or lower than 1980.

```hcl
ext_port = {
    dev = [1980, 70000],  // 70000 is invalid as it exceeds the maximum allowed port number
    prod = [1880, 1881]
}
```

2. **Run Terraform Plan:**

Execute `terraform plan` to apply the configuration changes.

```bash
terraform plan | grep external
```

3. **Expected Error Output:**

Terraform should return an error indicating that the port number for the dev environment is outside the valid range.

```bash
Error: Invalid value for variable
on line X:
X: variable "ext_port" {

The external port for dev must be in the range 1980 - 65535.
```

#### Testing for Prod Environment

1. **Modify `terraform.tfvars` for Prod Environment:**

Alter the external ports for the prod environment to values that violate the specified range. For example, set a port number in the dev range or outside the maximum allowed port number.

```hcl
ext_port = {
    dev = [1980, 1981]
    prod = [1880, 1982]  // 1982 is invalid as it falls into the dev port range
}
```

2. **Run Terraform Plan for Prod:**

Execute `terraform plan` specifying the prod environment.

```bash
terraform plan -var="env=prod" | grep external
```

3. **Expected Error Output:**

You should receive an error message stating that the port number for the prod environment is incorrect.

```bash
Error: Invalid value for variable
on line X:
X: variable "ext_port" {

The external port for prod must be in the range 1880 - 1979.
```

### Best Practices

Here are some best practices to consider when managing external ports:

1. **Use Maps for Port Configuration:** Use maps to define external ports for different environments. This makes it easier to update and manage ports when deploying to various environments.

2. **Validate Port Ranges:** Implement validation rules to ensure that external ports fall within the valid range (0 - 65535) and do not conflict with each other within the same environment.

3. **Environment-Specific Validation:** If you have different port ranges for dev and prod environments, create separate validation rules for each environment. Terraform allows you to specify conditions and error messages uniquely.

## Key Takeaways

Here are the key takeaways from this guide:

- Maps and lookups in Terraform are powerful tools for managing external ports in different environments.

- Use maps to define external ports for dev and prod environments.

- Implement validation rules to ensure that external ports are within the valid range and do not conflict.

## Conclusion

In this guide, we've explored how to manage external ports effectively using Terraform, including maps, lookups, and validation rules. Properly configuring external ports is essential for maintaining a secure and conflict-free infrastructure. We encourage you to apply these concepts to your own projects and experiment with different port configurations.

## References

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Terraform - lookup Function](https://developer.hashicorp.com/terraform/language/functions/lookup)
- [Types and Values](https://developer.hashicorp.com/terraform/language/expressions/types)