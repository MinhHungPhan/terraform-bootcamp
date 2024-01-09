# Maps and Lookups in Terraform

## Table of Contents

- [Introduction](#introduction)
- [Concepts](#concepts)
- [Usage and Examples](#usage-and-examples)
- [Hands-On Lab](#hands-on-lab)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to the world of efficient environment management in deployment using Terraform. This guide is tailored for both novices and seasoned professionals looking to streamline their deployment processes across different environments. We focus on utilizing maps and lookups to manage variables in development and production environments effectively. This approach is crucial, especially considering the differences in requirements and configurations between these environments.

## Concepts

Understanding maps and lookups is essential for efficient Terraform scripting.

### Maps

**Maps**: In Terraform, a map is a data structure used to associate keys with values. Each value can be accessed using its corresponding key, much like a dictionary in other programming languages. Maps are incredibly useful when you need to define a set of values based on a key. For instance, you could have a map of environment names ('dev', 'prod') to specific settings.

**Example of a Map**:

```hcl
variable "image" {
  type = map
  default = {
    dev = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}
```
### Lookups

**Lookups**: A lookup is a function in Terraform that retrieves a value from a map based on a given key. If the key exists in the map, the function returns the corresponding value. This is particularly useful when your Terraform configurations need to adapt based on different environments or settings.

**Example of Lookup Usage**:

```hcl
lookup(var.image, var.env)
```

In this example, `lookup` retrieves the image URL from the `image` map based on the current environment stored in `var.env`.

## Usage and Examples

We begin by setting up environment variables for development (dev) and production (prod). The `env` variable will dictate the deployment environment. This variable is crucial to prevent accidental deployments to the wrong environment. 

For example, setting the `env` variable:

```hcl
variable "env" {
  type = string
  default = "dev"
}
```

## Hands-On Lab

Follow these steps for a practical implementation:

1. **Clean Slate Setup**: 

- Run `terraform destroy --auto-approve` to ensure a fresh start.

2. **Setting Up Environment Variable**: 

- In `variables.tf`, add:

```hcl
variable "env" {
  type = string
  description = "Environment to deploy to"
  default = "dev"
}
```

3. **Defining Image Variable**:

- Continue in `variables.tf` to define the image map:

```hcl
variable "image" {
  type = map
  description = "Image for container"
  default = {
      dev = "nodered/node-red:latest"
      prod = "nodered/node-red:latest-minimal"
  }
}
```

4. **Testing in Terraform Console**: 

- Use Terraform console to test map lookups:

```hcl
> lookup({dev = "image1", prod = "image2"}, "dev")
image1

> lookup({dev = "image1", prod = "image2"}, "prod")
image2

> lookup(var.image, "dev")
nodered/node-red:latest

> lookup(var.image, "prod")
nodered/node-red:latest-minimal
```

5. **Implementing in main.tf**:

- Modify `main.tf` to use the image variable:

```hcl
resource "docker_image" "nodered_image" {
  name = lookup(var.image, var.env)
}
```

6. **Testing Deployments**:

- Test deployment for prod:

```bash
terraform plan -var="env=prod" | grep name
```

Expected output:

```
+ name = "nodered/node-red:latest-minimal"
```

- Test deployment for dev:

```bash
terraform plan | grep name
```

Expected output:

```
+ name = "nodered/node-red:latest"
```

## Best Practices

- Always default the environment to 'dev' to avoid accidental prod deployments.
- Keep your configurations modular and reusable.
- Regularly update and maintain your Terraform scripts.

## Key Takeaways

- Maps and lookups in Terraform are powerful tools for managing environment-specific configurations.
- Proper environment variable management can significantly reduce the risk of deployment errors.
- Terraform allows for scalable and maintainable infrastructure as code practices.

## Conclusion

This guide has introduced you to using maps and lookups in Terraform to manage different deployment environments efficiently. Embracing these practices will lead to more secure, efficient, and error-free deployments. We encourage you to experiment, contribute, and share your experiences with the community.

## References

- [Terraform - lookup Function](https://developer.hashicorp.com/terraform/language/functions/lookup)
- [Types and Values](https://developer.hashicorp.com/terraform/language/expressions/types)