# Variable Validation with Terraform

This tutorial aims to introduce the concept of variable validation in Terraform. It elucidates how to validate input values for variables to ensure they meet specific conditions before Terraform applies the changes.

## Table of Contents

- [Introduction](#introduction)
- [Variable Validation](#variable-validation)
  - [Example 1: Validating Port Number](#example-1-validating-port-number)
  - [Example 2: Validating Port Range](#example-2-validating-port-range)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Terraform is an open-source Infrastructure as Code (IaC) software tool that provides a consistent CLI workflow to manage hundreds of cloud services. One of the significant advantages of using Terraform is its ability to validate variable values. Before applying changes, Terraform checks the values provided for variables against predefined validation rules to ensure they meet specific criteria. This step ensures the integrity and correctness of configurations.

## Variable Validation

Terraform allows you to specify validation rules for input variables using the `validation` block within the `variable` block. The primary attributes used inside the validation block are:
- `condition`: A boolean expression that specifies the condition the variable value should satisfy.
- `error_message`: A descriptive error message that is displayed if the `condition` evaluates to `false`.

### Example 1: Validating Port Number

Suppose you want to ensure that the internal port for a Docker container is always `1880`. Here's how you can achieve this:

```hcl
variable "int_port" {
 type    = number
 default = 1881
 validation {
   condition     = var.int_port == 1880
   error_message = "The internal port must be 1880."
 }
}
```

When you run `terraform plan`, you will get the following error:

```js
Error: Invalid value for variable

  on main.tf line 12:
  12: variable "int_port" {
     ├────────────────
     │ var.int_port is 1881

The internal port must be 1880

This was checked by the validation rule at main.tf:16,3-13.
```

### Example 2: Validating Port Range

For another example, if you want to ensure that an external port number for a Docker container is within the valid port range of `0-65535`, you can set the following validation rule:

```hcl
variable "ext_port" {
 type    = number
 default = 76423
 validation {
   condition     = var.ext_port <= 65535 && var.ext_port > 0
   error_message = "The external port must be in the valid range 0 - 65535."
 }
}
```

Upon running `terraform plan`, you will encounter:

```js
Error: Invalid value for variable

  on main.tf line 22:
  22: variable "ext_port" {
     ├────────────────
     │ var.ext_port is 76423

The external port must be in the valid range 0 - 65535.

This was checked by the validation rule at main.tf:26,4-14.
```

## Conclusion

Variable validation in Terraform provides an extra layer of security and robustness to your infrastructure code. By setting up appropriate validation rules, you can ensure that your configurations are not only syntactically correct but also semantically valid. This way, potential issues can be caught early in the development cycle, reducing the chances of errors during infrastructure provisioning.

## References

- [Terraform Custom Validation Rules](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)