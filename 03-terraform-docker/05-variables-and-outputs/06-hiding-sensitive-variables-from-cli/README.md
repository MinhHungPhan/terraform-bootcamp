# Terraform Sensitive Variables

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setting up Variables](#setting-up-variables)
- [Applying Terraform Changes](#applying-terraform-changes)
- [Error: Output refers to sensitive values](#error-output-refers-to-sensitive-values)
- [Verifying Sensitive Values](#verifying-sensitive-values)
- [Cleaning Up](#cleaning-up)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this guide on handling sensitive values in Terraform. Terraform is a popular Infrastructure as Code (IaC) tool used for building, changing, and versioning infrastructure efficiently. In some cases, you might handle sensitive information like passwords, secret keys, or other confidential data. It is crucial to ensure that such sensitive information is not exposed in your command line interface (CLI) outputs or logs. Since Terraform version 0.14, a feature has been introduced to handle sensitive values securely: the sensitive flag. This guide will walk you through the steps to use this feature effectively.

## Prerequisites

Before we begin, ensure that you have the following prerequisites:

- Terraform installed (version 0.14 or later).
- Basic understanding of Terraform syntax and commands.

## Setting up Variables

Sensitive values can be marked in your Terraform configuration to prevent them from being displayed on the CLI. You can do this by adding `sensitive = true` to your variable declarations. Here’s how you can do it:

### variables.tf

```hcl
variable "ext_port" {
  type        = number
  sensitive  = true
  default     = 76423
  validation {
    condition     = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "The external port must be in the valid range 0 - 65535."
  }
}
```

In this example, we've marked `ext_port` as a sensitive variable. This means that Terraform will treat this variable's value as sensitive and will take care to not display it in the CLI output.

## Applying Terraform Changes

After marking your variables as sensitive, the next step is to apply your Terraform changes. Before doing this, make sure to destroy any existing infrastructure to ensure a clean state:

```bash
terraform destroy --auto-approve
terraform apply --auto-approve
```

Upon running `terraform apply`, you will notice that the output referring to sensitive values will not display the actual values but will instead mark them as sensitive.

Expected ouput:

```js
Error: Output refers to sensitive values

  on outputs.tf line 7:
  7: output "ip-address"
```

## Error: Output refers to sensitive values

The error message "Error: Output refers to sensitive values" in Terraform indicates that you are trying to output a value that is marked as sensitive, without marking the output itself as sensitive.

This can happen when you have a variable or a value within a resource that is marked as sensitive, and you are trying to expose this value through an output. Terraform requires that any output which includes sensitive information should also be marked as sensitive.

### How to Resolve the Issue

To resolve this issue, you need to mark the output as sensitive. Here is how you can modify the `outputs.tf` file:

#### outputs.tf

```hcl
output "ip-address" {
  value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The IP address and external port of the container"
  sensitive   = true
}
```

In this example, the `ip-address` output is referencing a value from a Docker container, and it includes the external port which is marked as sensitive. By adding `sensitive = true` to the output, you are telling Terraform to treat this output as sensitive and to not display its value in the CLI output.

### Checking the Result

### 1. Validate Terraform Configuration:

Run the `terraform validate` command in your Terraform directory. This command will help ensure that your configuration is syntactically valid and internally consistent.

```sh
terraform validate
```

If everything is set up correctly, it should return a message saying that the configuration is valid.

### 2. Plan the Changes:

Run the `terraform plan` command to see what changes Terraform intends to make based on your current configuration.

```sh
terraform plan
```

Review the plan to ensure that no unexpected changes are going to be made. Pay attention to the output section of the plan to see how the sensitive output is handled.

### 3. Apply the Changes:

If you’re satisfied with the plan, run the `terraform apply` command to apply the changes.

```sh
terraform apply --auto-approve
```

After applying the changes, Terraform will output the results. Sensitive outputs should be marked as `(sensitive value)` instead of showing the actual value.

## Verifying Sensitive Values

### 1. Test Accessing the Sensitive Output:

Try to access the sensitive output using the `terraform output` command:

```bash
terraform output
```

This command should display `<sensitive>` instead of the actual value for any output marked as sensitive.

### 2. Check Terraform State (Optional):

You can also check the Terraform state file to ensure that sensitive values are not stored in plaintext. However, make sure to be careful when dealing with the state file, as it can contain sensitive information.

```bash
terraform show | grep external
```

Even though this command shows the entire state, sensitive values will still be marked as sensitive and will not be displayed.

## Cleaning Up

Once you are done, you might want to clean up and remove the sensitive flags from your variables and outputs, especially if you are planning to use these values later in your Terraform configuration.

Simply remove the `sensitive = true` line from your variable and output declarations and apply the changes:

```bash
terraform apply --auto-approve
```

## Conclusion

Using the `sensitive` flag in Terraform is a straightforward and effective way to protect sensitive values and ensure they are not accidentally exposed in CLI outputs or logs. This feature enhances the security of your Terraform configurations and helps in maintaining best practices for handling confidential data.

## References

- [Terraform Documentation](https://www.terraform.io/docs/language/values/variables.html)
- [Output Values - Terraform by HashiCorp](https://www.terraform.io/language/values/outputs)
- [Sensitive Output Values - Terraform by HashiCorp](https://www.terraform.io/language/values/outputs#sensitive-output-values)
- [How-to output sensitive data with Terraform](https://support.hashicorp.com/hc/en-us/articles/5175257151891-How-to-output-sensitive-data-with-Terraform)