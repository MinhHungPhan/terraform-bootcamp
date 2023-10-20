# Terraform Variables and Output Files

Welcome to this guide, where we'll delve deep into the importance, structure, and best practices for Terraform's `variables` and `output` files.

## Table of Contents

- [Introduction](#introduction)
- [Understanding `variables.tf`](#understanding-variablestf)
- [Grasping `Outputs.tf`](#grasping-outputstf)
- [Benefits of Separation](#benefits-of-separation)
- [Breaking Up The Script](#breaking-up-the-script)
- [Terraform Actions](#terraform-actions)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

In Terraform, as the complexity of infrastructure grows, it becomes essential to maintain an organized structure. One of the best ways to achieve this is by separating variables and outputs into their respective files: `variables.tf` and `outputs.tf`.

## Understanding `variables.tf`

The `variables.tf` file is dedicated to defining all the variables you'll be using in your Terraform configurations. 

### Structure:

1. **Variable Declaration**: Define the variable and its type.
2. **Default Value**: Assign a default value (optional but recommended).
3. **Validation**: Set conditions to validate the variable's value (optional).

## Grasping `outputs.tf`

The `outputs.tf` file showcases the results of your Terraform deployments. It gives a clear view of the resources you've created and their configurations.

### Structure:

1. **Output Name**: Give your output a descriptive name.
2. **Value**: Define what information about your resource you want to display.
3. **Description**: Describe the output (optional but recommended).

## Benefits of Separation

1. **Clarity**: Segregating variables and outputs ensures your Terraform code is easier to read and understand.
2. **Maintainability**: Changes can be made quickly without the fear of unintentionally altering other sections of your code.
3. **Reusability**: Variables, especially, can be reused across different modules or environments, thus promoting DRY (Don't Repeat Yourself) principles.

## Breaking Up The Script

Terraform allows us to break our script into multiple files, which it considers for deployment as long as the file ends with `.tf`.

### Creating `variables.tf` and `outputs.tf`

1. First, create a new file named `variables.tf`.
2. Next, create another file named `outputs.tf`.
   
These files, as their names suggest, will hold our variables and outputs respectively.

#### Refactoring the Main Script:

- Cut the outputs from the main file.

```bash
Ctrl + X (Cut)
```

- Save the main file.
- Open `outputs.tf` and paste the outputs there.
- Similarly, cut the variables from the main file and paste them in `variables.tf`.

### Example:

`outputs.tf`:

```hcl
# Outputs
output "container_name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container"
}

output "ip_address" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The IP address and external port of the container"
}
```

`variables.tf`:

```hcl
# Variables
variable "int_port" {
  type        = number
  default     = 1880
  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

variable "ext_port" {
  type        = number
  default     = 76423
  validation {
    condition     = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "The external port must be in the valid range 0 - 65535."
  }
}

variable "container_count" {
  type    = number
  default = 1
}
```

## Terraform Actions

After restructuring, we can run Terraform commands to verify if everything is working as before:

1. Plan your infrastructure:

```bash
terraform plan
```

2. If everything looks fine, destroy any existing infrastructure:

```bash
terraform destroy -auto-approve && terraform apply -auto-approve
```

3. To confirm the changes, run:

```bash
terraform show | grep 1880
```

This ensures that despite the script refactor, Terraform still recognizes our resources and the deployment remains unchanged.

## Conclusion

Separating `variables` and `outputs` files in Terraform not only keeps your configurations tidy but also streamlines the workflow. It aids in understanding, maintenance, and scalability of your Terraform projects.

## References

- [Variables in Terraform](https://learn.hashicorp.com/tutorials/terraform/variables)
- [Outputs in Terraform](https://www.terraform.io/docs/language/values/outputs.html)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Terraform File Structure](https://learn.hashicorp.com/tutorials/terraform/organize-configuration?in=terraform/0-13)