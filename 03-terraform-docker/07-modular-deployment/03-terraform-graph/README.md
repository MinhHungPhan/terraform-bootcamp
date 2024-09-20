# Terraform Graph

Welcome to this guide on using Terraform Graph, one of the most valuable tools for visualizing and understanding your Terraform configurations. In this tutorial, we will walk through how to utilize `terraform graph`, which helps diagnose deployment issues, particularly with module flow, dependencies, and potential circular references. We'll also integrate Graphviz to turn the graph data into an easy-to-read visual format.

## Table of Contents

- [Introduction](#introduction)
- [Purpose and Scope](#purpose-and-scope)
- [Project Directory Structure](#project-directory-structure)
- [Setting Up Terraform Graph](#setting-up-terraform-graph)
- [Using Terraform Graph](#using-terraform-graph)
- [Visualizing with Graphviz](#visualizing-with-graphviz)
- [Testing Your Configuration](#testing-your-configuration)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

As your infrastructure grows, the complexity of understanding dependencies between modules, providers, and resources can increase. This is where Terraform Graph comes in. It generates a visual representation of your infrastructure configuration and its relationships, making it easier to spot issues such as circular dependencies or incorrect ordering.

In this tutorial, we will explore how to use `terraform graph` alongside Graphviz, a visualization tool, to better understand the flow and structure of your Terraform configuration.

## Purpose and Scope

The purpose of this document is to guide users in utilizing Terraform Graph for visualizing resource relationships in their configurations. We will show how to generate and interpret these dependency graphs, as well as how to install and use Graphviz to improve their readability.

## Project Directory Structure

Before diving into Terraform Graph, let's review the current directory structure for the project:

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
└── west.tfvars
```

These files will hold your core Terraform configurations for defining resources, outputs, and variables.

## Setting Up Terraform Graph

To start using Terraform Graph, you'll need a working Terraform setup. Ensure that you have Terraform installed and initialized in your project.

1. **Install Terraform** (if not already installed):

- Follow instructions from the official [Terraform installation guide](https://developer.hashicorp.com/terraform/downloads).

2. **Run Terraform Commands**:

- Initialize Terraform with the following command:

```bash
terraform init
```

## Using Terraform Graph

The `terraform graph` command generates a DOT graph of the Terraform configuration. It helps you see how the resources are interrelated, which can be particularly helpful for debugging.

Execute the `terraform graph` command:

```bash
terraform graph
```

This command outputs a graph in the DOT format, which isn't easy to read on its own. While this shows dependencies, it's hard to interpret without visual aid. That’s where Graphviz comes into play.

## Visualizing with Graphviz

To make the graph more readable, we’ll use Graphviz to convert the DOT output into a PDF or image format.

1. **Install Graphviz**:

- On Debian/Ubuntu systems, install Graphviz using the following command:

```bash
sudo apt install graphviz
```

- For other systems, check [Graphviz installation instructions](https://graphviz.org/download/).

2. **Generate Graphs with Graphviz**:

You can pipe the output of the `terraform graph` command into Graphviz to generate a visual representation.

```bash
terraform graph | dot -Tpdf > graph-plan.pdf
```

This will create a `graph-plan.pdf` file that you can open to see the graph visually.

## Testing Your Configuration

Before applying any configuration changes, it’s good practice to validate and plan your Terraform scripts.

1. **Validate Terraform Configuration**:

Run the following command to ensure your configuration is valid:

```bash
terraform validate
```

2. **Run Terraform Plan**:

The `terraform plan` command shows what actions Terraform will take to apply your configuration:

```bash
terraform plan
```

3. **Apply the Configuration**:

After verifying the plan, apply the configuration with:

```bash
terraform apply --auto-approve
```

4. **Generate an Applied Graph**:

Once the configuration is applied, you can generate a graph of the applied state:

```bash
terraform graph | dot -Tpdf > graph-applied.pdf
```

Open the `graph-applied.pdf` file to view the dependencies and confirm everything is in place.

5. **Generate and Compare Planned Destroy Graph**:

To understand the impact of potential destroy actions, you can generate a graph of the planned destroy state:

```bash
terraform graph -type=plan-destroy | dot -Tpdf > graph-destroy.pdf
```

Open the `graph-destroy.pdf` file and compare it with `graph-applied.pdf`. This comparison will help you visualize the differences between the current applied state and the planned destroy actions, allowing you to identify any critical dependencies or resources that will be affected.

6. **Commenting Out Outputs and Visualizing Planned Destroy Actions**

Sometimes, you may need to temporarily disable certain outputs in your Terraform configuration to focus on specific parts of your infrastructure. To comment out the lines in `outputs.tf`, you can use the `#` symbol at the beginning of each line:

```hcl
# output "ip_address" {
#   value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
#   description = "The IP address and external port of the container"
#   sensitive   = true
# }
```

This will effectively comment out the `output` block in the `outputs.tf` file, allowing you to exclude it from your current configuration.

After commenting out the outputs, you might want to visualize the planned destroy actions to understand the impact of these changes. To generate a graph of the planned destroy actions in your Terraform configuration, you can use the following command:

```bash
terraform graph -type=plan-destroy | dot -Tpdf > graph-noip.pdf
```

This command will create a `graph-noip.pdf` file that visualizes the dependencies and relationships of the planned destroy actions, helping you to see how the removal of certain outputs affects the overall infrastructure.

## Best Practices

1. **Keep Terraform Configurations Modular**: Breaking up your configurations into reusable modules makes it easier to maintain and understand complex infrastructures.
2. **Use Graphs to Identify Issues**: If you encounter issues with deployment order, resource dependencies, or circular references, `terraform graph` can help you quickly pinpoint the root cause.
3. **Version Lock Providers**: Always version-lock your providers to ensure consistency between deployments.
4. **Document Changes**: Keep detailed documentation of your infrastructure changes, particularly when modifying complex graphs.

## Key Takeaways

- **Terraform Graph** is an essential tool for understanding the dependencies in your Terraform configuration.
- **Graphviz** enhances the usability of Terraform Graph by converting DOT files into readable visual representations.
- By visualizing your infrastructure, you can spot errors and circular dependencies, ensuring smoother deployments.
- Always validate and test your configurations before applying them to avoid unexpected behavior.

## Conclusion

Using Terraform Graph in conjunction with Graphviz gives you a powerful way to visualize and troubleshoot your Terraform deployments. By generating easy-to-understand graphs, you can quickly identify dependency issues, improve resource management, and ensure that your configurations are applied correctly. As you continue to develop more complex infrastructure, this approach will help streamline your work and provide valuable insights into the structure of your deployments.

## References

- [Terraform Graph Documentation](https://developer.hashicorp.com/terraform/cli/commands/graph)
- [Graphviz Documentation](https://graphviz.org/)
- [Terraform Modules Overview](https://developer.hashicorp.com/terraform/language/modules)
- [Terraform Provider Versioning](https://developer.hashicorp.com/terraform/language/providers/requirements)