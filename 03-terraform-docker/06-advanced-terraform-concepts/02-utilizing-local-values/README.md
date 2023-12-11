# Utilizing Local Values in Terraform

## Introduction

Welcome to this detailed guide on utilizing localgit  values in Terraform, specifically focusing on managing external port allocations in Docker container deployments. Ideal for both beginners and experienced users, this guide will streamline your port allocation process, ensuring smooth coordination with network security teams.

## Table of Contents

- [Overview of Local Values](#overview-of-local-values)
- [Setting Up Your Environment](#setting-up-your-environment)
- [Understanding Common Misconceptions](#understanding-common-misconceptions)
- [Defining and Using Local Values](#defining-and-using-local-values)
- [Validating Port Assignments](#validating-port-assignments)
- [Testing Local Values](#testing-local-values)
- [Expected Outputs](#expected-outputs)
- [Conclusion](#conclusion)
- [References](#references)

## Overview of Local Values

Local values in Terraform are essential for enhancing the readability and maintainability of configurations. They are particularly beneficial for managing repeated values within a module.

## Locals vs Variables

In Terraform, both locals and variables are used to define values, but they serve different purposes and have distinct characteristics:

### Variables

1. **Purpose**: Variables in Terraform are primarily used for customizing aspects of Terraform modules or resources. They are similar to function arguments in programming languages. Variables make your Terraform configuration more dynamic and flexible.

2. **Definition**: Variables are defined in `.tf` files (commonly `variables.tf`). They can be assigned default values, but their actual values are often provided at runtime, either through `tfvars` files, command-line flags, or environment variables.

3. **Scope**: A variable is a way to inject external values into Terraform configuration. They can be made available to different modules, allowing for modular and reusable code.

4. **User Input**: Variables are intended to be set by the user or automation systems. They are the primary means by which users customize Terraform modules.

5. **Validation and Documentation**: Variables can be validated using validation blocks, and descriptions can be provided for user guidance.

### Locals

1. **Purpose**: Local values (locals) are used within a Terraform configuration to simplify and organize complex expressions. They are akin to variables within a programming script that are not exposed to the external user.

2. **Definition**: Locals are defined in a `locals` block within a Terraform configuration file. They are used to assign a name to an expression, so it can be used multiple times within a module without repeating the expression.

3. **Scope**: Local values are strictly module-scoped. They are meant to simplify internal module logic and are not accessible outside the module in which they are defined.

4. **Internal Simplification**: Locals are used to make a configuration easier to read and maintain. They are particularly useful for reducing repetition of the same value or expression within a module.

5. **No User Input**: Unlike variables, locals are not intended to be set by the user. They are set and used internally within the configuration.

### Key Differences

- **User Interaction**: Variables are meant for external input, while locals are for internal configuration simplification.
- **Scope**: Variables can be accessed by different modules, whereas locals are confined to the module they are defined in.
- **Purpose**: Variables provide a way to inject external values and customize behavior, while locals are used to simplify and organize the internal logic of a modul

### Scenario: Deploying Multiple Web Servers

Suppose you are deploying multiple web servers and need to configure their properties, like the number of servers, server types, and specific server settings.

#### Using Variables

Variables allow users or automation systems to provide input or configuration details externally.

**variables.tf**:

```hcl
variable "server_count" {
  description = "Number of web servers to deploy"
  type        = number
  default     = 3
}

variable "server_type" {
  description = "Type of server to deploy (e.g., 't2.micro')"
  type        = string
  default     = "t2.micro"
}
```

In this case, `server_count` and `server_type` are variables that can be set externally when running Terraform, allowing flexibility in deployment without changing the core code.

#### Using Locals

Locals are used to simplify internal logic and avoid repeating complex expressions.

**main.tf**:

```hcl
locals {
  common_tags = {
    Project = "Web Server Deployment"
    Owner   = "DevOps Team"
  }

  server_name_prefix = "web-server-"
}

resource "aws_instance" "web_server" {
  count         = var.server_count
  instance_type = var.server_type
  tags          = merge(
    {
      Name = "${local.server_name_prefix}${count.index}"
    },
    local.common_tags
  )
}
```

In this configuration:
- `common_tags` is a local value holding common tags to be applied to each server. This prevents repetition of the same tags across multiple resources.
- `server_name_prefix` is another local value used to construct the server names in a consistent manner.

#### Key Points in the Example

- **Variables (`server_count` and `server_type`)**: Set externally to determine how many servers to create and what type they should be. This allows the module user to customize these aspects without modifying the module itself.
- **Locals (`common_tags` and `server_name_prefix`)**: Used internally to simplify the configuration and avoid repetition. They are defined within the module and are not intended to be modified by the module user.

## Setting Up Your Environment

Begin by configuring your `variables.tf` and `terraform.tfvars` files:

1. Change the type to `list`:

**variables.tf**:

```hcl
variable "ext_port" {
  type        = list
  sensitive   = true
  default     = 76423
}
```

2. Add few more ports:

**terraform.tfvars**:

```hcl
ext_port = [1880, 1881, 1882]
```

## Understanding Common Misconceptions

Before diving into the correct usage of local values, let's address a common mistake in defining variables in Terraform.

Initially, you might attempt to set the `container_count` variable based on the length of `ext_port` directly within the `variable` block, like this:

**variables.tf** (Incorrect Approach):

```hcl
variable "container_count" {
    type    = number
    container_count = length(var.ext_port)
}
```

Now run the `terraform plan` command and pipe its output through `grep` to filter for lines containing 'external':

```bash
terraform plan | grep external
```

Expected output:

```js
Error: Function calls not allowed

  on variables.tf line 23, in variable "container_count":
   23:   container_count = length(var.ext_port)

Function calls are not allowed in variable declarations. You can use function calls in locals, or directly in resource fields.
```

This will result in a syntax error because you cannot assign a value to a variable in this manner in Terraform. Within a `variable` block, you can't assign a value using a function or reference another variable (`var.ext_port`). The `variable` block is meant for declaring variables, not for performing operations or referencing other variables.

## Defining and Using Local Values

Local values play a key role in dynamically managing resources, especially in Docker container and port management:

1. **Define a Local Value**: Establish `container_count` in a `locals` block, based on the length of the `ext_port` list.

**variables.tf**:

```hcl
locals {
    container_count = length(var.ext_port)
}
```

2. **Utilize the Local Value**:

- Modify your `random_string` resource in `main.tf` to use `local.container_count`.
- Modify your `docker_container` resource in `main.tf` to use `local.container_count`.

**main.tf**:

```hcl

resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
    count = local.container_count
    ...
    ports {
    external = var.ext_port[count.index]
    }
}
```

3. **Validate Configuration**: To check the external port settings, run `terraform plan` and use `grep` to filter the relevant output:

```bash
terraform plan | grep external
```

Expected output:

```bash
cloud_user:~/environment/terraform/terraform-docker (main) $ terraform plan | grep external
        + external = 1880
        + external = 1881
        + external = 1882
```

## Validating Port Assignments

Validation is essential to ensure that the container count does not exceed the number of available ports. Experiment with various `container_count` values to observe Terraform's responses.

## Testing Local Values

To test the local values, modify the `locals` block as follows:

```hcl
locals {
  container_count = length(var.ext_port) + 1
}
```

This modification deliberately sets the container count to be more than the available ports, allowing you to test the error handling of Terraform.

When the container count exceeds the available ports:

```bash
error: Invalid index
```

This output confirms the configuration's capability to prevent deploying more containers than there are ports available.

## Conclusion

This guide aims to provide a clear understanding of using local values in Terraform for efficient configuration management, particularly for Docker container port management. The techniques discussed here should help you implement these strategies effectively in your Terraform projects.

## References

- [Terraform Locals](https://developer.hashicorp.com/terraform/language/values/locals)