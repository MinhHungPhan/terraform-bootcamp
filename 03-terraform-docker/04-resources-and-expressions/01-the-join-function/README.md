# Terraform Functions: the Join Function

## Table of Contents

- [Introduction](#introduction)
- [Join Function Basics](#join-function-basics)
- [Practical Application: Joining IP Address and External Port](#practical-application-joining-ip-address-and-external-port)
    - [Locating the External Port](#step-1-locating-the-external-port)
    - [Identifying the IP Address](#step-2-identifying-the-ip-address)
    - [Joining IP Address and External Port](#step-3-joining-ip-address-and-external-port)
    - [Updating main.tf](#step-4-updating-maintf)
    - [Applying the Changes](#step-5-applying-the-changes)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

In this tutorial, we aim to unravel the intricacies of Terraform functions, focusing especially on the `join` function. If you've been programming before, you'll find Terraform functions strikingly familiar - they feature a function name followed by parentheses enclosing arguments. Let's dive in to demystify the concepts further.

## Join Function Basics

The `join` function in Terraform works similarly to many higher-level programming languages. It requires a separator and a list. The basic syntax is `join(separator, list)`, where the output is a string with the list elements joined by the separator. Let's illustrate this with a simple example:

```hcl
join(",", ["apple", "banana", "cherry"])
```

This would produce `apple,banana,cherry` as the output.

## Working with Terraform Console

To further illustrate, let's try some examples within the Terraform console. Enter the console by typing `terraform console` in your terminal. Once inside, you can start executing Terraform expressions.

For example, let's join a semicolon-delimited list:

```hcl
join(";", ["hello", "world"])
```

This produces the output `hello;world`. You can also add spaces within the separator for different output formatting.

## Practical Application: Joining IP Address and External Port

So far, we've covered the basics. But how can we apply this in a real-world scenario? Let's say you want to display the IP address and the external port where Node-RED (a Docker container) is exposed.

### Step 1: Locating the External Port

First, let's identify the Docker container's external port. Here's how you can access it, assuming the Docker container's name is "nodered_container":

```hcl
docker_container.nodered_container.ports[0].external
```
This will output:

```js
1880
```

### Step 2: Identifying the IP Address

Next, we need to retrieve the Docker container's IP address. Execute the following:

```hcl
docker_container.nodered_container.ip_address
```
You will receive an output like this:

```js
"172.17.0.2"
```

### Step 3: Joining IP Address and External Port

Having obtained the IP address and the external port, we can now join them. The format for an IP address and port combination is typically `IP_ADDRESS:PORT`. We can use the `join` function to achieve this, with a colon (":") as the separator:

```hcl
join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external ])
```

This should give us the desired output:

```js
"172.17.0.2:1880"
```

### Step 4: Updating main.tf

Having successfully joined the IP address and port, we can now incorporate these changes into our `main.tf` file:

```hcl
output "IP-Address" {
  value        = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
  description  = "The IP address and external port of the container"
}

output "Container-name" {
  value        = docker_container.nodered_container.name
  description  = "The name of the container"
}
```

### Step 5: Applying the Changes

Next, apply the changes using the `terraform apply --auto-approve` command:

```bash
terraform apply --auto-approve
```

This command applies the changes we've made and displays the `IP_ADDRESS:PORT` format we sought after.

You can verify the changes by running:

```bash
terraform output
```

This will yield the following output:

```js
Container-name = "nodered"
IP-Address = "172.17.0.2:1880"
```

## Conclusion

That concludes our introduction to the `join` function in Terraform. As you've seen, Terraform functions enable you to perform powerful operations, making your infrastructure code more flexible and concise. Although we focused on the `join` function, there are many more Terraform functions to explore. Keep practicing, and you'll soon become proficient at using these functions to better manage your infrastructure!

## References

- [Terraform Documenation - Join function](https://developer.hashicorp.com/terraform/language/functions/join)