# The Random Resource

# Table of Contents

- [Introduction](#introduction)
- [Problem Statement](#problem-statement)
- [Solution Approach](#solution-approach)
    - [Setup and Deploy Docker Container](#step-1-setup-and-deploy-docker-container)
    - [Deploying Multiple Docker Containers](#step-2-deploying-multiple-docker-containers)
    - [Generating Random Strings for Unique Container Names](#step-3-generating-random-strings-for-unique-container-names)
    - [Applying Changes](#step-4-applying-changes)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome! In this lesson, we'll address an essential aspect of Terraform deployments: the use of random strings. The concept might seem straightforward, but it plays a crucial role in enabling the independent scaling of resources without conflicts. In this tutorial, we'll show how you can use random strings to create unique names for your resources and prevent deployment issues.

## Problem Statement

Suppose you want to deploy multiple Docker containers and avoid naming conflicts. In this scenario, traditional methods like manually assigning names or ports aren't scalable or practical, especially if you want to deploy numerous resources.

## Solution Approach

### Step 1: Setup and Deploy Docker Container

1. Initially, we'll set up and apply the infrastructure for a Docker container named "nodered_container" using Terraform:

```hcl
resource "docker_container" "nodered_container" {
  name  = "nodered"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}
```

2. Once the setup is complete, use the command `terraform apply --auto-approve` to execute the deployment:

```bash
terraform apply --auto-approve
```

This command will create or update the resources as per the configuration file. The `--auto-approve` flag is used to skip interactive approval of plan before applying.

### Step 2: Deploying Multiple Docker Containers

To avoid naming conflicts, you can duplicate the above configuration and make minor modifications:

```hcl
resource "docker_container" "nodered_container2" {
  name  = "nodered2"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}
```

This second configuration creates another Docker container called "nodered_container2" to run in parallel with the first one.

### Step 3: Generating Random Strings for Unique Container Names

The manual renaming method doesn't scale for large deployments. Therefore, we will introduce the use of Terraform's random string resource. This resource generates a random string that can be attached to the end of our container names to ensure uniqueness.

1. Add the random string resource in the `main.tf` file:

```hcl
resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

resource "random_string" "random2" {
  length  = 4
  special = false
  upper   = false
}
```

2. Run the following command to apply the Terraform configuration:

```bash
terraform apply --auto-approve
```

3. After applying the configuration, you can list the resources managed by Terraform using the following command:

```bash
terraform state list
```

The expected output of the above command should be:

```js
docker_container.nodered_container
docker_container.nodered_container2
docker_image.nodered_image
random_string.random
random_string.random2
```

4. Next, we use the `join` function to add the random string to our container names:

```hcl
resource "docker_container" "nodered_container" {
  name  = join("-",["nodered",random_string.random.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}

resource "docker_container" "nodered_container2" {
  name  = join("-",["nodered",random_string.random2.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}
```

### Step 4: Applying Changes

1. Now we can apply these changes and observe the unique container names generated:

```hcl
output "IP-Address" {
  value       = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description = "The IP address and external port of the container"
}

output "Container-name" {
  value       = docker_container.nodered_container.name
  description = "The name of the container"
}

output "IP-Address2" {
  value       = join(":", [docker_container.nodered_container2.ip_address, docker_container.nodered_container2.ports[0].external])
  description = "The IP address and external port of the container"
}

output "Container-name2" {
  value       = docker_container.nodered_container2.name
  description = "The name of the container"
}
```

2. Execute `terraform apply --auto-approve` to apply the changes and view the outputs:

```bash
terraform apply --auto-approve
```

Output:

```js
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.


Outputs:


Container-name = "nodered-u7lk"
Container-name2 = "nodered-5upl"
IP-Address = "172.17.0.2:32771"
IP-Address2 = "172.17.0.3:32772"
```

## Conclusion

In this lesson, we've seen how to utilize Terraform's random string resource to prevent naming conflicts during mass resource deployment. This method ensures the uniqueness of each deployed resource, making our infrastructure setup robust and scalable. In the following lessons, we'll explore more of Terraform's capabilities.

## References

- [Terraform documentation - Random String](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)