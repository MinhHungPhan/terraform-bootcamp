# Utilizing Map Keys instead of Lookups

## Table of Contents

- [Introduction](#introduction)
- [Understanding Map Keys](#understanding-map-keys)
- [Understanding Lookups](#understanding-lookups)
- [Transitioning from Lookups to Map Keys](#transitioning-from-lookups-to-map-keys)
- [Updating `main.tf` for Map Key Utilization](#updating-maintf-for-map-key-utilization)
- [Updating `variables.tf` for Map Key Utilization](#updating-variablestf-for-map-key-utilization)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this comprehensive guide designed to enlighten beginners on the effective utilization of map keys in configurations, using Terraform as a case study. This document aims to demystify the concept of map keys and how they can be a more efficient alternative to lookups, especially in complex configurations. Our goal is to ensure that by the end of this guide, you'll have a clear understanding of how to implement map keys in your Terraform configurations, making your infrastructure as code (IaC) practices more streamlined and maintainable.

## Understanding Map Keys

Map keys are an essential feature in many programming and scripting languages, including HCL (HashiCorp Configuration Language) used by Terraform. They allow you to efficiently access values within a map or dictionary data structure using a specific key. This approach is not only more readable but also enhances the maintainability of your code.

## Understanding Lookups

Lookups in Terraform are a method used to fetch a value from a map based on a given key. While useful, lookups can become cumbersome and less efficient in complex configurations where direct access through keys can be more straightforward and less error-prone.

## Transitioning from Lookups to Map Keys

Transitioning from lookups to utilizing map keys directly simplifies code and reduces potential errors. It involves defining your resources and variables in a manner that leverages the map's keys directly instead of relying on a lookup function.

## Advantages of Using Map Keys Over Lookups

Using map keys directly instead of the `lookup` function in Terraform, or similar scenarios in other programming and configuration contexts, offers several benefits that can make your code cleaner, more efficient, and easier to maintain. Let's break down the reasons and benefits behind choosing direct map key access over lookups:

### 1. **Simplicity and Readability**

- **Direct Access**: Accessing values directly with map keys simplifies the syntax. It's more straightforward to read `var.ext_port[terraform.workspace]` than `lookup(var.ext_port, terraform.workspace)`, especially for someone new to your code.

- **Easier to Understand**: For those unfamiliar with Terraform or the specific codebase, understanding that you're accessing a map directly can be more intuitive than understanding the behavior of the `lookup` function.

### 2. **Error Handling**

- **Explicit Errors**: Using map keys directly can lead to more explicit and understandable error messages. If a key doesn't exist, Terraform will throw an error during the plan phase, making it clear that your configuration is missing a necessary piece. With `lookup`, you might get a null value or a default you set, potentially masking configuration errors until runtime.

- **Safer Defaults**: While `lookup` allows for a default value if a key doesn't exist, this can sometimes hide configuration issues. Direct key access encourages upfront configuration correctness.

#### Example: Using `lookup` with Default Values

Consider a scenario where you're setting up infrastructure with Terraform, and you have a map of instance types for different environments in your `variables.tf`:

```hcl
variable "instance_types" {
  description = "Instance types for different environments"
  type        = map(string)
  default     = {
    dev  = "t2.micro"
    prod = "t2.large"
  }
}
```

Now, imagine you accidentally misspell the environment key when you try to access this variable, and you use `lookup` to get the instance type, providing a default just in case:

```hcl
resource "aws_instance" "example" {
  instance_type = lookup(var.instance_types, "development", "t2.micro")
}
```

In this case, the key `"development"` does not exist in your map. However, instead of throwing an error, Terraform will use the default value `"t2.micro"`. This might lead you to believe everything is configured correctly, even though the configuration does not accurately reflect your intentions.

#### Example: Direct Map Key Access

Now, let's see what happens when you access the map directly, without the safety net of a default value:

```hcl
resource "aws_instance" "example" {
  instance_type = var.instance_types["development"]
}
```

With direct map key access, Terraform will throw an error during the planning phase because the key `"development"` does not exist. This error forces you to address the typo immediately, ensuring that your configurations accurately reflect your intentions and that there are no hidden mistakes due to incorrect assumptions or typos.

### 3. **Performance**

- **Efficiency**: Direct key access can be more efficient than a lookup, especially in large configurations or when dealing with complex data structures. While this might not be significantly noticeable in smaller Terraform projects, it contributes to best practices that scale with project complexity.

### 4. **Maintainability**

- **Refactoring and Scalability**: As your infrastructure grows, maintaining a clear and concise codebase becomes crucial. Direct map access is inherently more scalable and manageable, making it easier to refactor and expand your configurations.

- **Better for Collaboration**: When working in a team, clarity and ease of understanding are vital. Direct access patterns are generally easier for others to follow and contribute to, reducing the learning curve for new team members.

## Updating `main.tf` for Map Key Utilization

Let's revise a Terraform configuration that uses lookup to access external ports based on the workspace:

### Before:

```hcl
resource "docker_image" "nodered_image" {
  name = lookup(var.image, terraform.workspace)
}

# ... existing code ...

resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = var.int_port
    external = lookup(var.ext_port, terraform.workspace)[count.index]
  }
}
```

### After:

By replacing the lookup function with direct map key access, the configuration becomes more readable and efficient:

```hcl
resource "docker_image" "nodered_image" {
  name = var.image[terraform.workspace]
}

# ... existing code ...

resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
  }
}
```

## Updating `variables.tf` for Map Key Utilization

### Before:

```hcl
locals {
  container_count = length(lookup(var.ext_port, terraform.workspace))
}
```

Previously, the container count might not have been explicitly linked to the structure of your external ports variable, relying instead on indirect references or lookups.

### After:

And here's how you might adjust your `locals` within the `variables.tf` to ensure the container count is dynamically set based on the number of external ports defined for the current workspace:

```hcl
locals {
  container_count = length(var.ext_port[terraform.workspace])
}
```

In the updated approach, you directly use the workspace as a key to access the relevant array of external ports from your `ext_port` map. Then, you calculate the length of this array to determine the `container_count`. This method is not only more direct but also reduces the risk of errors associated with lookups, especially in configurations where workspaces have varying numbers of containers.

By setting up your variables and resources this way, you effectively remove the need for lookups. Instead, you directly access the values through map keys, which simplifies the code and improves its readability and maintainability.

## Best Practices

- **Use Descriptive Keys**: Choose keys that clearly describe the values they represent, making your configurations easier to understand.
- **Keep Maps Organized**: Structure your maps in a way that they are easily maintainable, especially when dealing with multiple environments.
- **Regularly Review Map Usage**: As your infrastructure evolves, ensure your maps and keys remain relevant and refactor as needed.

## Key Takeaways

- Utilizing map keys over lookups simplifies and enhances the readability of your Terraform configurations.
- Direct key access is generally more efficient and less error-prone than using lookup functions.
- Adopting best practices in key naming and map organization can significantly improve the maintainability of your code.

## Conclusion

This guide introduced the concept of using map keys as a more efficient alternative to lookups in Terraform configurations. By embracing this approach, you can make your IaC practices more streamlined, readable, and maintainable. Remember, the journey to mastering Terraform is continuous, and adopting efficient practices like utilizing map keys is a step in the right direction.

## References

- [Terraform - map Function](https://developer.hashicorp.com/terraform/language/functions/map)
- [Terraform - lookup Function](https://developer.hashicorp.com/terraform/language/functions/lookup)
- [Best Practices for Terraform Configuration](https://www.hashicorp.com/blog/best-practices-for-terraform-configuration)