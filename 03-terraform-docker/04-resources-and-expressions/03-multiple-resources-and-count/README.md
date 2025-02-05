# Multiple Resources and Count

## Table of Contents

- [Introduction](#introduction)
- [Utilizing the Count Feature in TerraForm](#utilizing-the-count-feature-in-terraform)
- [Hands-On](#hands-on)
  - [Creating the resources](#step-1-creating-the-resources)
  - [Using the `count` argument](#step-2-using-the-count-argument)
  - [Using `count.index`](#step-3-using-countindex)
  - [Managing Outputs](#step-3-managing-outputs)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this practical guide on simplifying and managing your TerraForm code. If you're new to TerraForm or you've been using it but have been struggling to manage and structure your code, you're in the right place. This tutorial aims to explain how you can use features such as `count` to create reusable and manageable TerraForm code. Let's start with the fundamental concept of DRY (Don't Repeat Yourself) in programming and how to implement it in TerraForm.

## Utilizing the Count Feature in TerraForm

The first thing you need to know is that TerraForm provides a feature called `count`, which allows you to avoid code duplication. For instance, if you want to create multiple similar resources, instead of duplicating the same block of code multiple times, you can use the `count` argument.

First, ensure you have no hanging resources by running a `terraform destroy` command:

```bash
terraform destroy --auto-approve
```

## Hands-On

Let's now refactor your existing Terraform code from [the previous tutorial](/03-terraform-docker/04-resources-and-expressions/02-the-random-resource/README.md) to incorporate the `count` argument. 

### Step 1: Creating the resources

Suppose you have the following Terraform resources:

**main.tf**:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}
```

### Step 2: Using the `count` argument

In this scenario, we'll use the `count` argument with the `random_string` and `docker_container` resources to create two instances of each resource.

1. To generate two unique random strings, add the `count` argument to the `random_string` resource:

```hcl
resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}
```

2. Now, run the following command to create the resources:

```bash
terraform apply --auto-approve
```

🎯 **Example Output**:

```js
docker_image.nodered_image: Creating...
docker_image.nodered_image: Creation complete after 2s [id=sha256:123abc456def789ghi]
random_string.random[0]: Creating...
random_string.random[1]: Creating...
random_string.random[0]: Creation complete after 0s [id=xyz1]
random_string.random[1]: Creation complete after 0s [id=abcd]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

3. To inspect the current status of your Terraform-managed infrastructure, execute the following command:

```bash
terraform show
```

This command offers a comprehensive output of the current state of your Terraform resources, encompassing any modifications that have occurred within your infrastructure.

You should see an output like this:

```js
# random_string.random[0]:
resource "random_string" "random" {
   id          = "cli5"
   length      = 4
   lower       = true
   min_lower   = 0
   min_numeric = 0
   min_special = 0
   min_upper   = 0
   number      = true
   numeric     = true
   result      = "cli5"
   special     = false
   upper       = false
}


# random_string.random[1]:
resource "random_string" "random" {
   id          = "xc92"
   length      = 4
   lower       = true
   min_lower   = 0
   min_numeric = 0
   min_special = 0
   min_upper   = 0
   number      = true
   numeric     = true
   result      = "xc92"
   special     = false
   upper       = false
}
```

### Step 3: Using `count.index`

How do we reference these resources now that a `count` argument has been added? This is where `count.index` becomes useful. It provides access to the index of each iteration of the resource being created. For instance, in the "nodered_container" resource, we are referencing each "random_string" resource using `count.index`. This guarantees that every Docker container receives a unique name.

1. Modify the `docker_container` resource to include `count.index` when referencing `random_string`:

```hcl
resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = 1880
    # external = 1880
  }
}
```

2. Now, let's apply this configuration:

```bash
terraform apply --auto-approve
```

🎯 **Example Output**:

```js
random_string.random[0]: Creating...
random_string.random[1]: Creating...
random_string.random[0]: Creation complete after 0s [id=xyz1]
random_string.random[1]: Creation complete after 0s [id=abcd]

docker_container.nodered_container[0]: Creating...
docker_container.nodered_container[1]: Creating...
docker_container.nodered_container[0]: Creation complete after 3s [id=a1b2c3d4e5f6]
docker_container.nodered_container[1]: Creation complete after 3s [id=f6e5d4c3b2a1]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

As depicted in the output, both random strings have been generated successfully, and the containers have been created accordingly. 

By using `count.index`, each container is assigned a unique name based on the corresponding `random_string` instance.

## Step 4: Managing Outputs

Now, let's explore how to handle outputs. Do remember, you cannot use `count.index` within the output block, as it is not a counted context. However, you can leverage the index to access each individual container.

1. Consider the following example where we try to add a counter index to the output block:

```hcl
output "Container-name" {
 value       = docker_container.nodered_container[count.index].name
 description = "The name of the container"
}
```

2. After saving this configuration, execute the `terraform apply --auto-approve` command:

```bash
terraform apply --auto-approve
```

The result may look like this:

```js
╷
│ Error: Reference to "count" in non-counted context
│
│   on main.tf line 39, in output "Container-name":
│   39:   value       = docker_container.nodered_container[count.index].name
│
│ The "count" object can only be used in "module", "resource", and "data" blocks, and only when the "count"
│ argument is set.
╵
```

This error message indicates that the "count" object is only permitted within "module", "resource", and "data" blocks and only when the "count" argument is explicitly defined. As a result, its use here is invalid.

This key insight should always be kept in mind for successful Terraform scripting.

3. Now, let's rectify the error in the previous block and showcase the proper output configuration:

```hcl
output "IP-Address" {
  value       = join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
  description = "The IP address and external port of the container"
}

output "Container-name" {
  value       = docker_container.nodered_container[0].name
  description = "The name of the container"
}

output "IP-Address2" {
  value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
  description = "The IP address and external port of the second container"
}

output "Container-name2" {
  value       = docker_container.nodered_container[1].name
  description = "The name of the second container"
}
```

4. Reapply the configuration:

```bash
terraform apply --auto-approve
```

🎯 **Example Output**:

```js
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.


Outputs:


Container-name = "nodered-cli5"
Container-name2 = "nodered-xc92"
IP-Address = "172.17.0.3:32769"
IP-Address2 = "172.17.0.2:32768"
```

With these changes, the outputs should now display as expected. But can we optimize this process and maintain the DRY (Don't Repeat Yourself) principle like we did with the resources? Keep reading to the next section to discover!

## Conclusion

In this guide, we've learned about the `count` argument and how it can help make our TerraForm code more manageable and easier to understand. We've also learned how to access the resources we've created with `count` using `count.index` and how to handle the outputs. 

## References

- [The count Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [Don't Repeat Yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
