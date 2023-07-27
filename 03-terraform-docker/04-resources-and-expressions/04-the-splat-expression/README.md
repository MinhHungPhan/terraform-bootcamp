# Terraform Splat Expression

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Understanding Splat Expressions](#understanding-splat-expressions)
- [Hands-On](#hands-on)
  - [Testing Splat Expressions with Terraform Console](#step-1-testing-splat-expressions-with-terraform-console)
  - [Using Splat Expressions in main.tf](#step-2-using-splat-expressions-in-maintf)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this tutorial where we will be discussing a fascinating aspect of Terraform - the Splat Expression! In the world of Terraform, Splat Expressions add a splash of excitement and dynamism. This tutorial is dedicated to unpacking and understanding this fun and highly practical tool. We'll be learning about its application, usefulness, and more, all with hands-on examples to ensure that you grasp the concept.

## Prerequisites

This tutorial assumes that you have a basic understanding of Terraform and its syntax, especially the use of the `count` meta-argument. If you're not yet familiar with these, take some time to brush up before diving in.

## Understanding Splat Expressions

The Splat Expression, aptly named for its appearance (`[*]`), is an expression analogous to a `for loop`. It lets you reference all resources created by `count` in a compact manner. By employing this technique, we can simplify our Terraform scripts, making them more maintainable and reducing redundancy.

For instance, assume you've created several resources using `count`, and now you want to output certain properties of these resources. Without the Splat Expression, you'd have to define an output for each instance - a time-consuming and redundant task. This is where the Splat Expression comes into play, enabling us to neatly handle all these instances in one fell swoop!

## Hands-On

### Step 1: Testing Splat Expressions with Terraform Console

Let's say you've recently deployed some resources. To begin, make sure to destroy your last deployment to clear the way for the next one:

```bash
terraform destroy --auto-approve
```

Don't worry if you're wondering why we typically destroy before starting again; it's an easy way to prevent potential problems and ensure a smooth transition from one lesson to another.

Apply your configuration once again, creating your resources:

```bash
terraform apply --auto-approve
```

Now, we'll try to use the Splat expression to consolidate our duplicate container name outputs into one output. This is especially useful if you're deploying numerous containers – imagine having to create a new output for each one!


Navigate to your Terraform console. This can be done using the command `terraform console`:

```bash
terraform console
```

Run the following command to use the Splat expression:

```bash
> docker_container.nodered_container[*].name
[
 "nodered-8pg8",
 "nodered-qwot",
]
```

This command returns all names of the created Docker containers. You're essentially asking for the names of all `nodered_container` instances that have been created. Whether there are zero or a thousand, this command will fetch the names of all of them.

### Step 2: Using Splat Expressions in main.tf

Let's see the Splat Expression in action. In [the previous tutorial](/03-terraform-docker/04-resources-and-expressions/03-multiple-resources-and-count/README.md) we have created two Docker containers using the `count` meta-argument. Now we want to output their names. Instead of defining an output for each container, we can use the Splat Expression:

```hcl
output "Container-name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the container"
}
```

With `[*]`, we are effectively saying, "Give me all the instances of `nodered` Docker containers that have been created and then retrieve the `name` attribute for each of them." When this code is run, the output is an array of the names of all the containers.

Now, let's try to apply the Splat Expression for outputting IP addresses:

```hcl
output "IP-Address" {
  value       = join(":", [docker_container.nodered_container[*].ip_address, docker_container.nodered_container[*].ports[0].external])
  description = "The IP address and external port of the container"
}
```

Now let's apply the change:

```bash
terraform apply --auto-approve
```

Expected Output:

```js
Error: Invalid function argument

  on main.tf line XX, in output "IP-Address":
   XX:   value = join(":", [docker_container.nodered_container[*].ip_address, docker_container.nodered_container[*].ports[0].external])

Invalid value for "lists" parameter: incorrect list element type: element 0 is tuple with 2 elements, but string is required.
```

When you are creating two Docker containers (using the count attribute), `docker_container.nodered_container[*].ip_address` and `docker_container.nodered_container[*].ports[0].external` are returning a list of values rather than a single value.

The `join` function is then trying to concatenate a list of IP addresses and a list of port numbers together, which is not what you want.

**Explanation**:

The `join` function is trying to glue together two pieces of information: IP addresses and port numbers of your Docker containers. But because you're creating two Docker containers (as specified by `count = 2`), you end up with two IP addresses and two port numbers.

Imagine having two pieces of paper with these written on them:

Paper 1: ["IP address 1", "IP address 2"]
Paper 2: ["Port 1", "Port 2"]

The `join` function can't stick together two pieces of paper; it needs individual strings (like "IP address 1" and "Port 1") to glue together.

Your original Terraform configuration is trying to glue the whole papers together, which Terraform doesn't understand. Hence, the error message you're seeing.

Don't fret! There are alternative ways to handle this which you'll uncover as you delve deeper into Terraform.

Remember, it's always good practice to destroy previous deployments before starting a new one to avoid complications.

## Conclusion

The Splat Expression is a powerful tool in Terraform, simplifying our code and making it more maintainable. It truly shows its value when you have to deal with multiple resource instances. Through practice and use, you'll be able to leverage this feature to write more efficient and streamlined Terraform scripts.

Stay curious, keep learning, and explore the many other interesting features of Terraform. Until the next tutorial, happy Terraforming!

## References

- [Terraform Documentation - Splat Expressions](https://developer.hashicorp.com/terraform/language/expressions#splat-expressions)