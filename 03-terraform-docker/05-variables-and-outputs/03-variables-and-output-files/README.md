# Terraform Variables and Output Files

Welcome to this guide, where we'll delve deep into the importance, structure, and best practices for Terraform's `variables` and `output` files.

## Table of Contents

- [Introduction](#introduction)
- [Understanding `variables.tf`](#understanding-variablestf)
- [Grasping `Outputs.tf`](#grasping-outputstf)
- [Understanding the "No Outputs Found" Warning](#understanding-the-no-outputs-found-warning)
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

### How outputs.tf Works with the State File

- **outputs.tf**: This file defines what information you want Terraform to “output” after it runs. These are typically important values, like resource names, IP addresses, or URLs.
- **Terraform State File (terraform.tfstate)**: This hidden file records the real, current values of all resources managed by Terraform—including the actual values for your outputs.

#### The Link:

1. When you run terraform apply, Terraform creates or updates resources and calculates the output values defined in outputs.tf.
2. Terraform saves these output values in the terraform.tfstate file.
3. When you run terraform output, Terraform reads the values from the state file and displays them to you.

#### Diagram: How Outputs Flow in Terraform

```plaintext
+----------------+      +----------------------+      +----------------------+
|  outputs.tf    | ---> |  terraform.tfstate   | ---> | terraform output     |
| (defines what  |      | (stores actual       |      | (displays outputs    |
|  to output)    |      |  output values)      |      |  to user)            |
+----------------+      +----------------------+      +----------------------+
```

- **outputs.tf**: You declare what you want to see (e.g., container names, IPs).
- **terraform.tfstate**: Terraform stores the actual values after creating/updating resources.
- **terraform output**: You or other automation tools can read and use these outputs.

#### Example: Outputs and State File

Suppose you have a Terraform configuration to create an AWS EC2 instance. You want to output the public IP address of the instance after creation.

**Step 1: Define the output in outputs.tf**

```hcl
output "instance_public_ip" {
  value = aws_instance.example.public_ip
  description = "The public IP address of the EC2 instance"
}
```

**Step 2: Apply Terraform**

When you run terraform apply, Terraform will:
- Create the EC2 instance.
- Discover the real public IP (e.g., 54.180.22.33).
- Save this value in the terraform.tfstate file under the outputs section.

**Step 3: Inspect the state file (simplified output)**

```json
{
  "outputs": {
    "instance_public_ip": {
      "value": "54.180.22.33",
      "type": "string",
      "description": "The public IP address of the EC2 instance"
    }
  }
  // ... rest of the state data ...
}
```

**Step 4: Get the output**

When you run terraform output instance_public_ip, Terraform reads the value from the state file and prints:

```
54.180.22.33
```

**Summary:**  

- outputs.tf defines what you want to output.
- The actual value is stored in terraform.tfstate after resources are created.
- terraform output lets you retrieve and display these values easily.

## Understanding the "No Outputs Found" Warning

When you run `terraform output` and see the "No outputs found" warning, it indicates that Terraform can't find any output values in its state file. Here's why this happens and how to resolve it:

### Why This Happens

```bash
terraform output
╷
│ Warning: No outputs found
│
│ The state file either has no outputs defined, or all the defined outputs are empty. Please define an output in your configuration with the `output`
│ keyword and run `terraform refresh` for it to become available. If you are using interpolation, please verify the interpolated value is not empty. You
│ can use the `terraform console` command to assist.
```

This warning occurs in one of these scenarios:

1. **You've defined outputs in `outputs.tf` but haven't run `terraform apply` yet**
2. **Your state file is out of sync with your configuration**
3. **The output values reference resources that don't exist yet**
4. **The output values are evaluating to empty/null**

### How to Resolve It

After defining your outputs in `outputs.tf`, you need to either:

1. **Run `terraform apply`**: This creates/updates your resources and records their actual values in the state file.

```bash
terraform apply
```

2. **Run `terraform refresh`**: This updates the state file based on the real-world infrastructure without making changes.

```bash
terraform refresh
```

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