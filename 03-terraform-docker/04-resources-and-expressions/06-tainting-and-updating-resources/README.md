# Tainting and Updating Resources

## Table of Contents

- [Introduction](#introduction)
- [Understanding Tainting](#understanding-tainting)
- [Getting Started with Tainting](#getting-started-with-tainting)
- [Hands-On](#hands-on)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this lesson on Terraform's tainting feature. If you've ever found yourself needing to force a resource to be destroyed and reapplied, this guide is for you. Tainting can be handy when you need to reload or reapply a configuration. We'll cover this concept with practical examples.

## Understanding Tainting

Tainting a resource allows you to mark it so that it will be destroyed and replaced the next time you apply your configuration. This is useful when you need to change some underlying feature without manually modifying the configuration.

### Common Reasons for Tainting:

- Reapplying a changed configuration from a repository or shared volume.
- Refreshing the state of a resource.

## Getting Started with Tainting

Before proceeding with the tainting process, make sure to destroy any existing resources to start on a clean slate:

```bash
terraform destroy --auto-approve
```

### Caution:

Terraform apply can be dangerous if you are unaware of the behavior with specific resources. Always use `terraform plan` when working in production to understand what will happen.

## Hands-On

### Simple Tainting and Applying

Here's a straightforward example to help you understand tainting. First, set the count from 2 to 1 in the [main.tf](/03-terraform-docker/04-resources-and-expressions/05-for-loops/terraform-docker/main.tf) from the previous tutorial.

```hcl
resource "random_string" "random" {
  count   = 1
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nodered_container" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
  }
}
```

Then, apply your configuration:

```bash
terraform apply --auto-approve
```

To taint a resource:

```bash
terraform taint random_string.random[0]
```

To untaint a resource:

```bash
terraform untaint random_string.random[0]
```

### Changing the Count

You can experiment with changing the count of resources and observe the behavior:

```bash
terraform plan
terraform apply --auto-approve
```

### Cleanup

To destroy the entire stack:

```bash
terraform destroy --auto-approve
```

## Conclusion

Tainting resources in Terraform is a powerful feature that enables you to force resources to be destroyed and reapplied as needed. It is essential to understand the dependencies and use tainting carefully. Practice with the examples provided to get hands-on experience.

## References

- [Terraform Official Documentation on Tainting](https://www.terraform.io/docs/cli/commands/taint.html)
- [Understanding Terraform's Behavior](https://www.terraform.io/docs/internals/resource-behavior.html)