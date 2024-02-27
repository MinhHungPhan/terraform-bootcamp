# Referencing Terraform Workspaces

## Table of Contents

- [Introduction](#introduction)
- [Understanding Terraform Workspaces](#understanding-terraform-workspaces)
- [Referencing Workspaces in Configurations](#referencing-workspaces-in-configurations)
- [Practical Example: Environment-Specific Resources](#practical-example-environment-specific-resources)
- [Hands-On Lab](#hands-on-lab)
- [Best Practices for Workspace Referencing](#best-practices-for-workspace-referencing)
- [Common Pitfalls and How to Avoid Them](#common-pitfalls-and-how-to-avoid-them)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to our comprehensive guide on Referencing Terraform Workspaces! In this document, we aim to delve into the advanced uses of Terraform Workspaces, focusing on how to effectively reference them within your Terraform configurations. This technique is pivotal for dynamically managing resources across multiple environments, such as development, staging, and production, without the need to duplicate code or rely heavily on external variables. Whether you're a beginner looking to expand your Terraform skills or an experienced practitioner aiming for more efficient infrastructure management, this guide will equip you with the knowledge to leverage workspaces to their full potential.

## Understanding Terraform Workspaces

Terraform Workspaces allow you to manage separate states of your infrastructure under the same configuration, making it easier to deploy and manage similar infrastructure across different environments. Before diving into workspace referencing, it's crucial to have a solid grasp of how to create and switch between workspaces and understand their benefits and limitations.

## Referencing Workspaces in Configurations

Referencing the current Terraform workspace allows you to dynamically alter your infrastructure based on the environment you're targeting. This is done using the `terraform.workspace` interpolation, which provides the name of the current workspace as a string.

### Syntax and Usage

```hcl
resource "some_resource" "name" {
  name = "${terraform.workspace}-resource"
}
```

This example prefixes the resource name with the current workspace name, allowing for easy identification and environment-specific configurations.

## Practical Example: Environment-Specific Resources

Consider a scenario where you need to deploy resources with environment-specific configurations, such as different sizes for a VM in development vs. production.

```hcl
resource "cloud_instance" "example" {
  count = terraform.workspace == "prod" ? 5 : 1

  name = "instance-${terraform.workspace}-${count.index}"
  size = terraform.workspace == "prod" ? "large" : "small"
}
```

This configuration creates a single small instance for any workspace other than `prod` and five large instances for the `prod` workspace.

## Hands-On Lab

### Step 1: Explore Terraform Workspace

1. **Open Terraform Console**:

- Run `terraform console` to open the interactive console.
- Check your current workspace with `terraform.workspace`. It should return `default`.

2. **Switch Workspaces**:

- Exit the console (CTRL + C).
- Create or switch to a production workspace with `terraform workspace select prod`.
- Re-enter the console and run `terraform.workspace` again. It should now return `prod`.

### Step 2: Modify Terraform Configuration

1. **Update Variables File (`variables.tf`)**:

- Remove the environment variable block entirely:

```hcl
variable "env" {
  type = string
  description = "Environment to deploy to"
  default = "dev"
}
```

- Replace references to `var.env` with `terraform.workspace` in any local definitions or resource configurations to dynamically reference the current workspace:

locals {
  container_count = length(lookup(var.ext_port, terraform.workspace))
}

2. **Update Main Configuration File (`main.tf`)**:

- Adjust resource definitions to utilize `terraform.workspace` for dynamic naming or configuration:

In the **docker_image** resource:

```hcl
resource "docker_image" "nodered_image" {
  name = lookup(var.image, terraform.workspace)
}
```

In the **docker_container** resource:

```hcl
resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = var.int_port
    external = lookup(var.ext_port, terraform.workspace)[count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol"
  }
}
```

**Note**: To enhance visibility, append the workspace name to your container names.

```hcl
resource "docker_container" "nodered_container" {
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
}
```

- This dynamically adjusts the number of resources, names, and configurations based on the active workspace.

### Step 3: Apply and Verify Changes

1. **For the `prod` Environment**:

- Ensure you're in the `prod` workspace with `terraform workspace show`:

```bash
terraform workspace show
```

- Review changes specifically affecting external ports with `terraform plan | grep external`:

```bash
terraform plan | grep external
```

**Expected output**:

```bash
+ external = 1880
+ external = 1881
```

2. **Switch to the `dev` Environment**:

- Change to the `dev` workspace using `terraform workspace select dev`:

```bash
terraform workspace select dev
```

- Again, review changes with `terraform plan | grep external`:

```bash
terraform plan | grep external
```

**Expected output**:

```bash
+ external = 1980
+ external = 1981
```

3. **Apply Configuration**:

- Apply your configuration with `terraform apply --auto-approve` to implement the changes. This step should be repeated for both workspaces to observe the dynamic adjustments based on the workspace.

## Best Practices for Workspace Referencing

- **Use Environment-agnostic Configurations**: Keep your configurations as environment-agnostic as possible, using workspace references to make minor adjustments.
- **Naming Conventions**: Adopt a consistent naming convention for workspaces and resources to avoid confusion and facilitate easier management.
- **Avoid Overuse**: While powerful, overusing workspace-specific logic can lead to complex and hard-to-maintain configurations. Strive for balance.

## Common Pitfalls and How to Avoid Them

- **Hardcoding Workspace Names**: Avoid hardcoding workspace names in conditions. Instead, consider using maps or variables to define environment-specific values.
- **Complex Logic**: Complex conditional logic based on workspace names can make configurations difficult to read and maintain. Simplify where possible.

## Key Takeaways

- Referencing Terraform Workspaces in configurations enables dynamic and flexible infrastructure management across multiple environments.
- Proper use of workspace references can significantly reduce code duplication and simplify environment-specific deployments.
- Balance and simplicity should be maintained to ensure configurations remain manageable and understandable.

## Conclusion

Referencing Terraform Workspaces is a powerful technique that, when used wisely, can enhance your infrastructure's flexibility and manageability across various environments. By adhering to best practices and avoiding common pitfalls, you can maximize the benefits of workspace references and maintain clean, efficient Terraform configurations. As you become more comfortable with these concepts, you'll find new and innovative ways to leverage Terraform Workspaces in your projects.

## References

- [Terraform Workspaces Documentation](https://developer.hashicorp.com/terraform/language/state/workspaces)
- [Managing Workspaces](https://developer.hashicorp.com/terraform/cli/workspaces)
