# Securing Sensitive Variables using tfvars Files

## Table of Contents

- [Introduction](#introduction)
- [Understanding Variable Definitions in Terraform](#understanding-variable-definitions-in-terraform)
- [Securing Sensitive Variable Definitions](#securing-sensitive-variable-definitions)
- [Creating the `.tfvars` File](#creating-the-tfvars-file)
- [Updating Variable Definitions](#updating-variable-definitions)
- [Testing Our Configuration](#testing-our-configuration)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this guide on securing your variable definitions in Terraform. As we build and manage infrastructures, the way we handle variables, especially sensitive ones, plays a crucial role in maintaining the security and integrity of our systems. In this tutorial, we'll learn how to properly manage and secure variable definitions, using `variables.tf` and `.tfvars` files. Our focus will be on ensuring that sensitive information is not inadvertently committed to version control, thereby preserving the confidentiality of our infrastructure's configuration.

## Understanding Variable Definitions in Terraform

Variable definitions in Terraform are commonly stored in a file named `variables.tf`. This file includes declarations of variables used within your Terraform configuration, typically found in your `main.tf` file. These declarations allow Terraform to interactively request values or use default values if none are provided by the user. 

For example, a basic `int_port` variable declaration in `variables.tf` might look like this:

```hcl
variable "int_port" {
  type        = number
  default     = 1880
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}
```

## Securing Sensitive Variable Definitions

While keeping variable definitions in `variables.tf` is essential, you must be cautious not to expose sensitive data, such as passwords or private keys. If your `main.tf` file references these sensitive variables, you would still include the variable block in the `variables.tf` for structure and documentation, but without the sensitive values hardcoded.

## Creating the `.tfvars` File

A `.tfvars` file is where you can define values for your variables that you don't want to commit to source control. You should configure your version control system (such as Git) to ignore this file using a `.gitignore` entry.

Here is how you can create a `terraform.tfvars` file:

1. Create a new file named `terraform.tfvars`.
2. Add your sensitive variable definitions to this file.

For instance, here's how you define an `ext_port` variable in `terraform.tfvars`:

```hcl
ext_port = 1880
```

Make sure to add the `terraform.tfvars` file to your `.gitignore` to prevent it from being committed:

```
# .gitignore entry
*.tfvars
```

## Updating Variable Definitions

Once you've set up your `.tfvars` file, you need to remove any sensitive default values from the `variables.tf` file and only leave the variable declaration structure intact. Here's how you can update it:

1. Open your `variables.tf` file.
2. Remove sensitive default values or replace them with generic placeholders.
3. Save the file.

## Testing Our Configuration

After setting up your variables and `.tfvars` files, test your configuration with the following Terraform commands:

```shell
# Destroy any existing infrastructure to start fresh
terraform destroy --auto-approve

# Preview changes without applying them
terraform plan

# Apply changes to create the infrastructure
terraform apply --auto-approve
```

You should see Terraform using the values defined in your `terraform.tfvars` file without exposing them to source control.

## Conclusion

By following the steps outlined in this guide, you've learned how to secure your variable definitions in Terraform. Using a `.tfvars` file is a best practice for managing sensitive values, ensuring they are kept out of version control and reducing the risk of exposing sensitive information.

As you continue learning Terraform, remember that security is not a one-time setup but a continuous process of validation and improvement. Always review and refine your approach to handling sensitive configuration details.

## References

For more information on variable definitions and security best practices in Terraform, refer to the following resources:

- [Terraform: Input Variables](https://www.terraform.io/docs/language/values/variables.html)
- [Terraform: Assigning Variables](https://www.terraform.io/docs/language/values/variables.html#assigning-values-to-root-module-variables)
- [GitHub: .gitignore Template for Terraform](https://github.com/github/gitignore/blob/master/Terraform.gitignore)

Keep exploring and happy coding! 🚀