# Troubleshooting Dependencies

Welcome back to our Terraform series! In this tutorial, we will dive deeper into **Terraform Graph** and learn how to identify and resolve dependency issues in Terraform configurations. We'll explore how implicit and explicit dependencies work, and how to effectively use `terraform graph` to troubleshoot and fix problems.

## Table of Contents

- [Introduction](#introduction)
- [Purpose and Scope](#purpose-and-scope)
- [Project Setup](#project-setup)
- [Understanding Dependency Issues](#understanding-dependency-issues)
    - [Implicit Dependencies](#implicit-dependencies)
    - [Explicit Dependencies](#explicit-dependencies)
- [Hands-On Lab](#hands-on-lab)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

As infrastructure scales, managing dependencies becomes increasingly complex. Occasionally, resources may fail to deploy in the correct order, leading to issues such as resource conflicts, permission errors, or incomplete setups. In this tutorial, we’ll demonstrate how to use **Terraform Graph** to visualize and resolve these issues, leveraging implicit and explicit dependencies for optimal infrastructure behavior.

## Purpose and Scope

This guide aims to:
- Help users understand how dependencies work in Terraform.
- Demonstrate how to identify and fix dependency issues using Terraform Graph.
- Provide hands-on exercises to solidify these concepts.

By the end of this tutorial, you'll know how to confidently troubleshoot and manage Terraform dependencies.

## Project Setup

Before we begin, ensure your project directory is set up as follows:

```
terraform-docker
├── central.tfvars
├── image
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── terraform.tfvars
├── variables.tf
├── west.tfvars
└──noderedvol/  # Ensure this folder is deleted during exercises.
```

## Understanding Dependency Issues

### Implicit Dependencies

Implicit dependencies are automatically derived when one resource references another's attributes. For example, if a container depends on a volume path, Terraform will recognize the dependency.

Example:

```hcl
resource "docker_container" "example" {
  name  = "example-container"
  volumes {
    container_path = "/data"
    host_path      = null_resource.docker_vol.id
  }
}
```

In this case, the `docker_container` resource implicitly depends on `null_resource.docker_vol` because its `id` is used.

### Explicit Dependencies

Explicit dependencies are manually specified using the `depends_on` argument. This ensures Terraform knows the exact resource relationship.

Example:

```hcl
resource "docker_container" "example" {
  depends_on = [null_resource.docker_vol]
  name       = "example-container"
}
```

Here, the `docker_container` will only be created after `null_resource.docker_vol`.

## Hands-On Lab

### Step 1: Adjust the Port Configuration

1. **Set Only One Port for Each Environment**:

Update `terraform.tfvars` to use a single port for each environment:

```hcl
ext_port = {
   dev  = [1980]
   prod = [1880]
}
```

### Step 2: Reproduce the Dependency Issue

1. **Create a Delay in Resource Creation**:

Update `null_resource.docker_vol` to simulate a delay:

```hcl
resource "null_resource" "docker_vol" {
    provisioner "local-exec" {
    command = "sleep 60 && mkdir -p noderedvol/ && sudo chown -R 1000:1000 noderedvol/"
    }
}
```

2. **Delete the `noderedvol` Folder**:

```bash
rm -rf noderedvol
```

3. **Deploy the Resources**:

```bash
terraform apply --auto-approve
```

4. **Check Docker Status**:

```bash
docker ps -a
```

You'll notice the container is created before the volume, causing a failure.

### Step 3: Visualize the Dependency

Generate the Terraform graph:

```bash
terraform graph | dot -Tpdf > graph-before-fix.pdf
```

Inspect the graph to see the lack of dependency between the container and volume.

### Step 4: Fix with Implicit Dependencies

1. Update `main.tf`:

```hcl
resource "docker_container" "nodered_container" {
    name = join("-", ["nodered", terraform.workspace, null_resource.docker_vol.id])

    volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol"
    }
}
```

2. Regenerate the Graph:

```bash
terraform graph | dot -Tpdf > graph-implicit.pdf
```

The graph now shows the implicit dependency.

3. Redeploy:

```bash
terraform apply --auto-approve
```

4. Verify:

```bash
docker ps -a
```

### Step 5: Fix with Explicit Dependencies

1. Update `main.tf`:

```hcl
resource "docker_container" "nodered_container" {
    depends_on = [null_resource.docker_vol]
    name       = "nodered-container"
}
```

2. Regenerate the Graph:

```bash
terraform graph | dot -Tpdf > graph-explicit.pdf
```

The graph now shows an explicit dependency.

3. Redeploy and Verify.

## Best Practices

1. **Use Explicit Dependencies for Clarity**: When dependencies are critical, prefer `depends_on` for precise control.
2. **Minimize Circular Dependencies**: Avoid creating interdependent resources that can lead to deadlocks.
3. **Regularly Visualize Configurations**: Use `terraform graph` and Graphviz to audit and troubleshoot infrastructure dependencies.
4. **Document Dependencies**: Clearly document implicit and explicit dependencies for better team collaboration.

## Key Takeaways

- Terraform manages dependencies automatically, but explicit dependencies can provide better control.
- Visualizing dependency graphs helps identify and resolve complex issues.
- Use `terraform graph` with Graphviz to generate clear, actionable insights.
- Always test and validate configurations before deploying to production.

## Conclusion

In this tutorial, we explored how to troubleshoot dependency issues using Terraform Graph. By understanding and leveraging implicit and explicit dependencies, you can create more reliable and maintainable Terraform configurations. Remember to visualize your dependencies regularly and adopt best practices to avoid future issues.

## References

- [Terraform Graph Documentation](https://developer.hashicorp.com/terraform/cli/commands/graph)
- [Graphviz Documentation](https://graphviz.org/)
- [Terraform Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners)