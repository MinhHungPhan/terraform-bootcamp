# Variable Definition Precedence

Welcome to this comprehensive guide on variable definition precedence in Terraform. In this tutorial, we’ll explore how `.tfvars` files are used to define variables for different deployment environments and understand the precedence rules that Terraform follows when multiple variable definitions are available.

## Table of Contents

- [Introduction](#introduction)
- [What are `.tfvars` Files?](#what-are-tfvars-files)
- [Managing Variables for Multiple Environments](#managing-variables-for-multiple-environments)
- [Using Variable Files in Terraform Commands](#using-variable-files-in-terraform-commands)
- [Overriding Variables from the Command Line](#overriding-variables-from-the-command-line)
- [Precedence Rules for Variables in Terraform](#precedence-rules-for-variables-in-terraform)
- [Practical Examples](#practical-examples)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Terraform allows for flexible infrastructure management by letting you define environment-specific variables using `.tfvars` files. These files tailor the settings for various conditions without altering the main Terraform configuration. This guide will illustrate the methods for using `.tfvars` files across different environments and explain how Terraform determines which variable values to use when the same variable is defined in multiple places.

## What are `.tfvars` Files?

`.tfvars` files are created to hold variable values that should be ignored by version control systems due to their potential sensitivity or their specificity to a certain environment. The Terraform files named `terraform.tfvars` or `*.auto.tfvars` are loaded by default, while other variable files must be specified when performing Terraform operations.

## Managing Variables for Multiple Environments

Handling different configurations for deployments across various conditions such as geographical regions, deployment stages, or other criteria is often necessary. This can be efficiently managed by defining environment-specific `.tfvars` files, such as `east.tfvars` for the East Coast and `west.tfvars` for the West Coast.

## Using Variable Files in Terraform Commands

To apply a set of variables defined in a `.tfvars` file to your Terraform plan, you can use the `terraform plan --var-file` option followed by the name of your desired file, as shown in the examples provided below.

## Overriding Variables from the Command Line

Terraform also offers the flexibility to override variables by specifying them directly on the command line with the `-var` option. This allows for on-the-fly adjustments without modifying any files.

## Precedence Rules for Variables in Terraform

Terraform's variable precedence is clear: command-line options take precedence over `.tfvars` file variables. This means that any variable defined via the command line will override the same variable's value defined in a `.tfvars` file or within the Terraform configuration itself.

## Practical Examples

The following snippets provide a clear picture of variable precedence in action:

```hcl
# File: west.tfvars
ext_port = 1980
```

```hcl
# File: central.tfvars
ext_port = 1990
```

To deploy with variables defined in `west.tfvars`:

```shell
terraform plan --var-file west.tfvars
```

To deploy with variables defined in `central.tfvars`:

```shell
terraform plan --var-file central.tfvars
```

To override the `ext_port` variable directly via the command line:

```shell
terraform plan -var "ext_port=1990"
```

## Conclusion

Throughout this guide, you've learned how to work with `.tfvars` files to manage environment-specific variables in Terraform and the importance of understanding variable precedence to ensure that the correct values are applied to your configurations. With this knowledge, you can better manage and automate your Terraform workflows for various environments and scenarios.

## References

- [Terraform documentation on variables](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence).

Please consider this lesson complete and feel free to proceed to the next one to continue expanding your understanding of Terraform's capabilities. Happy Coding! 🚀