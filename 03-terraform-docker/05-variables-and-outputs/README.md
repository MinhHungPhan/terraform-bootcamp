# Variables and Outputs

Welcome to the **Variables and Outputs** course! This course is designed to help you master the use of variables and outputs in Terraform, which are essential for creating dynamic and reusable infrastructure configurations. By learning how to effectively manage and secure variables, you will enhance your ability to work with complex Terraform setups.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Sub-directories Overview](#sub-directories-overview)
    - [Adding Variables](#adding-variables)
    - [Variable Validation](#variable-validation)
    - [Variables and Output Files](#variables-and-output-files)
    - [Sensitive Variables and tfvars Files](#sensitive-variables-and-tfvars-files)
    - [Variable Definition Precedence](#variable-definition-precedence)
    - [Hiding Sensitive Variables from CLI](#hiding-sensitive-variables-from-cli)
- [Support](#support)
- [Conclusion](#conclusion)

## Introduction

The **Variables and Outputs** course covers advanced Terraform techniques for managing variables and outputs. This course will teach you how to define variables, validate input, securely handle sensitive data, and manage output files. Additionally, you’ll learn about the precedence of variable definitions and how to hide sensitive variables from the command line interface (CLI).

## Prerequisites

Before starting this course, ensure you have the following:
- Completed the [**Basics of Terraform**](../02-basics-of-terraform/README.md), [**State Management**](../03-state-management/README.md), and [**Resources and Expressions**](../04-resources-and-expressions/README.md) courses, or have similar knowledge at a fundamental level of Terraform.
- Familiarity with the command line and basic scripting concepts.
- Installed versions of Docker, Git, and Terraform.

## Sub-directories Overview

### [Adding Variables](01-adding-variables/README.md)

This module introduces the basics of adding variables to your Terraform configurations. You’ll learn how to define variables in your `main.tf` file and how to pass values to these variables during runtime.

### [Variable Validation](02-variable-validation/README.md)

In this module, you'll explore Terraform's variable validation features. Learn how to enforce specific rules and constraints on variables to ensure that only valid input is used in your configurations.

### [Variables and Output Files](03-variables-and-output-files/README.md)

This module covers the use of variables and output files in Terraform. You’ll learn how to define variables in a `variables.tf` file, manage outputs in an `outputs.tf` file, and organize your Terraform code for better readability and reuse.

### [Sensitive Variables and tfvars Files](04-sensitive-variables-and-tfvars-files/README.md)

Handling sensitive data is critical in infrastructure management. This module teaches you how to define and use sensitive variables in Terraform, as well as how to manage them securely using `tfvars` files.

### [Variable Definition Precedence](05-variable-definition-precedence/README.md)

Understanding the precedence of variable definitions is key to controlling how variables are set in different environments. This module explores the order in which Terraform evaluates variable definitions from different sources like `tfvars` files, environment variables, and the CLI.

### [Hiding Sensitive Variables from CLI](06-hiding-sensitive-variables-from-cli/README.md)

In the final module, you'll learn techniques for hiding sensitive variables from being exposed in the CLI. This is crucial for maintaining security when running Terraform commands.

## Support

If you have any questions or need help, you can:
- Open an issue in the GitHub repository
- Contact the course maintainers via email at support@kientree.com
- Join our community Slack channel for real-time assistance

## Conclusion

Thank you for participating in the **Variables and Outputs** course! Mastering the use of variables and outputs will enable you to write more flexible, secure, and maintainable Terraform configurations. We encourage you to practice the techniques covered in this course to further solidify your understanding. Happy learning! 🌱