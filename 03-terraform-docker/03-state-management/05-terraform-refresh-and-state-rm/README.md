# Terraform: Understanding the `refresh` and `state` Commands

Welcome to this guide on understanding Terraform's `refresh` and `state` commands, as well as how they impact the state and your existing resources.

## Table of Contents

- [Introduction](#introduction)
- [Setup](#setup)
- [Exploring `terraform refresh`](#exploring-terraform-refresh)
- [Managing Terraform State](#managing-terraform-state)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Terraform is a powerful infrastructure-as-code tool. As you work with Terraform, it's crucial to know how commands like `refresh` and `state` work, especially since they can directly manipulate and display the state of your resources.

## Setup

Before diving deep, let's ensure we're all starting from the same point:

1. If you have not done so, clear your resources with:

```bash
terraform destroy --auto-approve
```

2. Ensure your count for your random string and Docker container is set to one.

```hcl
resource "random_string" "random" {
  count   = 1
  length  = 4
  special = false
  upper   = false
}
```

3. Apply your configurations:

```bash
terraform apply --auto-approve
```

Your setup should now be complete and ready for further actions.

## Exploring `terraform refresh`

### Displaying Current State

You can view your current Terraform state with:

```bash
terraform state list
```

### Modifying Outputs and Refreshing

Changing an output doesn't alter the actual resource. For instance, consider a scenario where you update the name of the `nodered_container` resource:

```hcl
resource "docker_container" "nodered_container" {
 count = 1
 name  = join("-",["nodereeeed",random_string.random[count.index].result])
 image = docker_image.nodered_image.latest
 ports {
   internal = 1880
   # external = 1880
 }
}
```

Now, let's run this following command:

```bash
terraform refresh
```

The change is reflected in the state's outputs, but not in the actual infrastructure.

To observe this distinction, you can use `terraform output` to review the outputs, and subsequently, `terraform state list` to inspect the state of your resources.

### Resource Changes and Refresh Behavior

It's important to note that certain changes, like the length of a random string, might require a new resource creation. Running `terraform refresh` in these cases won't make a visible change.

For instance, consider this resource modification:

```hcl
resource "random_string" "random" {
  count   = 1
  length  = 5
  special = false
  upper   = false
}
```

### Targeting Specific Resources

Terraform allows you to target specific resources during a refresh:

```bash
terraform refresh -target=random_string.random
```

## Managing Terraform State

### Syncing State with Infrastructure

If there's a mismatch between your actual infrastructure and the Terraform state (e.g., a container was deleted outside of Terraform), use:

```bash
terraform refresh
```

This command updates the state file to match the real infrastructure. However, note that it doesn't update the output.

### Manually Modifying State

In exceptional cases, you may need to remove items from the state. You can do this with:

```bash
terraform state rm <resource_type.resource_name>
```

Remember, manually manipulating state is risky and should only be done in emergencies. Terraform will generate a backup of the state every time you use the `state rm` command.

## Conclusion

This guide explored the `refresh` and `state` commands in Terraform. While these are powerful tools, always exercise caution, especially with manual state manipulations. Regularly reviewing and practicing these concepts ensures your infrastructure management remains smooth and error-free.

Thank you for following along! Ensure to run `terraform destroy` if needed, and we look forward to guiding you in the next lesson!

## References

- [Terraform Refresh Documentation](https://developer.hashicorp.com/terraform/cli/commands/refresh)
- [Terraform state rm command Documentation](https://developer.hashicorp.com/terraform/cli/commands/state/rm)

