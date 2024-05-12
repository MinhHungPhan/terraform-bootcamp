# Creating First Module

Welcome! If you're stepping into the world of modular infrastructure, particularly for production environments, you've come to the right place. This guide will walk you through the process of creating your first module in Terraform. Modules are essential for managing complex infrastructures because they allow you to reuse code and keep your configurations tidy and organized. By the end of this tutorial, you'll have a functional Docker image module ready for deployment.

## Table of Contents

- [Introduction](#introduction)
- [Understanding Terraform Modules](#understanding-terraform-modules)
- [Setting Up Your First Module](#setting-up-your-first-module)
- [Testing the Module](#testing-the-module)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

In this lesson, we will simplify our Terraform configurations by modularizing a Docker image. Currently, our configuration may seem straightforward, but as we scale and require repetitive settings, the benefits of modules become clear. For instance, having identical settings across various builds such as "pull triggers" or "keep locally" directives can be centralized within a module, reducing redundancy and clutter in the main `main.tf` file.

## Understanding Terraform Modules

### What is a Terraform Module?

A Terraform module is a container for multiple resources that are used together. Modules are a key component in Terraform for organizing and managing related resources in a structured way. They allow you to encapsulate a group of resources and related configuration into reusable, manageable, and shareable units. Essentially, a module can be considered as a sub-directory containing a collection of `.tf` or `.tf.json` files that together describe a set of resources.

### Why Use Modules?

Modules serve several important purposes in Terraform:

- **Reusability**: Modules can be reused across different projects or within the same project multiple times, saving time and effort in configuring resources that are frequently required.
- **Manageability**: By organizing resources into logical groups, modules help keep your Terraform configuration tidy and easier to maintain.
- **Encapsulation**: Modules encapsulate complexity. Users of the module need not understand the details of the internal workings of the module to use its functionality.
- **Versioning and Sources**: Modules can be versioned and shared through Terraform registries or even via git repositories, allowing you to control and distribute updates in a predictable manner.

### How Do Modules Work?

Modules are called from within other Terraform configurations using module blocks. When a module is called, Terraform will include all the resources defined within that module as part of the Terraform run. Inputs (variables) can be passed to the module to customize its behavior, and outputs can be accessed to use values computed by the module (such as resource IDs or computed names).

Example of calling a module:

```hcl
module "network" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"
  name = "vpc-name"
  cidr = "10.0.0.0/16"
  azs  = ["us-west-1a", "us-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
```

In the above example, the `network` module creates a complete VPC setup with both private and public subnets.

### Incorporating Modules into Your Projects

Incorporating modules into your Terraform projects not only promotes best practices such as DRY (Don't Repeat Yourself) and modular design but also aids in building complex infrastructures in a more manageable way. As you develop more in Terraform, leveraging modules will become an essential skill.

## Setting Up Your First Module

### Cleaning Up

Before creating our module, let’s tidy up a bit. We’ll start by moving our provider blocks, which have been in our main script for a while, into a new file to maintain clarity as we dive deeper into more complex Terraform structures.

```hcl
# providers.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15.0"
    }
  }
}

provider "docker" {}
```

### Creating the Module

Now, let's create our module. We'll focus on a Docker image:

1. **Create a New Folder**: Name it `image`.
2. **Add Necessary Files**: Similar to the root module, you will need several files:
   - `variables.tf`
   - `main.tf`
   - `outputs.tf`
   - `providers.tf`

These files will contain settings specific to the Docker image we want to manage.

**image/main.tf**:

```hcl
# Resources
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}
```

**image/output.tf**:

```hcl
# Outputs
output "image_out" {
  value = docker_image.nodered_image.latest
}
```

### Integrating the Module

In the root `main.tf`, reference the module you just created:

```hcl
module "image" {
  source = "./image"
}

resource "docker_container" "nodered_container" {
  image = module.image.image_out
}
```

## Testing the Module

Once you've integrated the Docker image module into your `main.tf`, follow these steps to initialize and apply your configuration to verify everything is set up correctly:

1. **Initialize the Terraform Configuration**:

Run the `terraform init` command to initialize the module and download necessary providers. This step prepares your project for further actions like planning and applying changes.

```bash
terraform init
```

2. **Plan the Execution**:

Execute the `terraform plan` command to see the changes that Terraform plans to make to your infrastructure according to your configuration files. This is a crucial step for reviewing changes before they are applied.

```bash
terraform plan
```

3. **Apply the Configuration**:

Use the `terraform apply` command to apply the changes required to reach the desired state of the configuration. The `--auto-approve` flag skips interactive approval of plan before applying.

```bash
terraform apply --auto-approve
```

## Best Practices

1. **Keep It DRY**: Don't Repeat Yourself (DRY) is crucial in module design. Reuse configurations to minimize errors and redundancy.
2. **Documentation**: Always document your modules and their variables. This aids in maintenance and usability by other team members.
3. **Version Control**: Use version constraints for providers to ensure compatibility and prevent unexpected changes.

## Key Takeaways

- Modules are essential for maintaining scalable, manageable infrastructure code in Terraform.
- Proper structuring and organization of Terraform configurations reduce errors and improve deployment efficiency.
- Transitioning to a modular approach helps in managing repetitive configurations centrally.

## Conclusion

By now, you should have a fundamental understanding of how to create and integrate a module in Terraform for a Docker image. Modules streamline your infrastructure management and enhance code reusability and maintainability. Continue exploring Terraform modules to further optimize your infrastructure setups.

## References

- [Modules Overview](https://developer.hashicorp.com/terraform/language/modules)
- [Creating Modules in Terraform](https://developer.hashicorp.com/terraform/language/modules/develop)