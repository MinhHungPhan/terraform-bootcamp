# Terraform Variables

Welcome to this lesson on Terraform variables. Variables are the building blocks in Terraform and, indeed, in most programming paradigms. They empower developers to dynamically and succinctly configure deployments, enhancing flexibility and reusability. In this guide, you will learn the essentials of defining, configuring, and using variables in Terraform.

## Table of Contents

- [Introduction](#introduction)
- [Configuring and Importing Variables](#configuring-and-importing-variables)
- [Specifying Variables](#specifying-variables)
- [Advanced Tips on Variables](#advanced-tips-on-variables)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Variables serve as placeholders for data. In Terraform, variables offer a way to represent configuration information, enabling one to parameterize configurations and reuse them in different scenarios. 

## Configuring and Importing Variables

### Basics

Input variables in Terraform are straightforward. You can set defaults, use objects, maps, and more. Their syntax aligns with what you'd find in Terraform resources.

```hcl
variable "example_variable" {}
```

Variables can be provided:
- Directly from the `main.tf` file
- Via the command line
- From `Variables.tf` files

For beginners, starting with the `main.tf` file is recommended.

### Defining a Variable

Let's define a variable named `ext_port`. This variable can be added to the `main.tf` file, typically below the provider definition:

```hcl
variable "ext_port" {}
```

To reference this variable elsewhere in your configuration, you'd use the syntax `var.ext_port`.

Example:

```hcl
resource "docker_container" "nodered_container" {
 count = 1
 name  = join("-",["nodered",random_string.random[count.index].result])
 image = docker_image.nodered_image.latest
 ports {
   internal = 1880
   external = var.ext_port
 }
}
```

## Specifying Variables

While variables offer flexibility, they can become cumbersome if not given a default value. Without defaults, Terraform prompts for input each time a command is run, which can be tedious.

To provide a default value:

```hcl
variable "ext_port" {
 type    = number
 default = 1880
}
```

With this, running `terraform plan` won't prompt for the `ext_port` value.

For values you don't wish to save or that change often, you can provide variables directly from the command line:

```bash
terraform plan -var ext_port=1880
```

## Advanced Tips on Variables

### Using Environment Variables

For further convenience or in CI/CD scenarios, Terraform can use environment variables:

```bash
export TF_VAR_ext_port=1880
```

To utilize an environment variable, prefix it with `TF_VAR_`. Ensure you have the prefix to make it work. If you ever need to remove the variable:

```bash
unset TF_VAR_ext_port
```

### Challenge

Now that you're familiar with setting up the `ext_port` variable, try creating variables for the internal port (`int_port`) and container count (`container_count`):

```hcl
variable "int_port" {
 type    = number
 default = 1880
}

variable "container_count" {
 type    = number
 default = 1
}
```

Remember to reference them in your resources with the `var.` prefix.

## Conclusion

Congratulations! You've learned how to leverage variables in Terraform to make your configurations more dynamic and reusable. As you delve deeper into Terraform, remember the power and flexibility that variables provide. We hope this guide has been helpful and wish you the best in your Terraform journey.

## References

- [Terraform Documentation - Input Variables](https://www.terraform.io/docs/language/values/variables.html)