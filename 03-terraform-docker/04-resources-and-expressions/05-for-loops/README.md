# Terraform For Expressions

Welcome to this lesson where we cover the powerful feature of "for expressions" in Terraform. Terraform's addition of "for expressions" aligns it with modern programming languages and opens up various new possibilities.

## Table of Contents

- [Introduction](#introduction)
- [Understanding For Expressions](#understanding-for-expressions)
- [Hands-On: Using For Expression to Handle IP and Ports](#hands-on-using-for-expression-to-handle-ip-and-ports)
    - [Accessing Container Names](#step-1-accessing-container-names)
    - [Accessing Ports](#step-2-accessing-ports)
    - [Combining IP Addresses and Ports](#step-3-combining-ip-addresses-and-ports)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

In the world of Terraform, "for expressions" have become an important tool. They allow us to handle complex structures and data without nesting too many functions. The focus of this lesson is on understanding how "for expressions" work and how to utilize them efficiently.

## Understanding For Expressions

For expressions are used to transform data structures in a more flexible and expressive way. Let's have a closer look at how to work with for expressions:

### Basic Example

You can start playing with the for expression by opening the Terraform console:

```bash
terraform console
```

Here's a simple example:

```hcl
> [for i in [1,2,3]: i + 1]
# Output:
[
 2,
 3,
 4,
]
```

This expression takes the numbers 1, 2, and 3, and adds 1 to each, resulting in 2, 3, and 4.

## Hands-On: Using For Expression to Handle IP and Ports

In this section, we'll work through an example of using for expressions to handle IP addresses and ports.

### Step 1: Accessing Container Names

```hcl
> [for i in docker_container.nodered_container[*]: i.name]
# Output:
[
 "nodered-8pg8",
 "nodered-qwot",
]
```

### Step 2: Accessing Ports

We have 2 ways of accessing ports

**Option 1**:

```hcl
> [for i in docker_container.nodered_container[*]: i.ports[0]["external"]]
# Output:
[
 32771,
 32770,
]
```

#### Explanation

In Option 1, we are using a for-loop to iterate through each container in `docker_container.nodered_container`, and for each container, we're accessing the first element (index 0) inside the `ports` list and then grabbing the value associated with the "external" key.

The output is a flat list of integers, representing the external port numbers.

#### When to Use

Option 1 is useful when you know that the `ports` list has a specific structure where the relevant information is always in the first element (index 0). It's more rigid and assumes that the data structure will not change.

**Option 2**:

```hcl
> [for i in docker_container.nodered_container[*]: i.ports[*]["external"]]
# Output:
[
 tolist([
   32771,
 ]),
 tolist([
   32770,
 ]),
]
```

#### Explanation

Option 2 uses a different approach. By using the splat (`*`) operator instead of a specific index (like 0), we are asking Terraform to loop through all elements inside the `ports` list for each container, and then get the value associated with the "external" key.

The output is a list of lists, where each inner list contains one integer representing an external port number. This makes the output slightly more complex than Option 1.

#### When to Use

Option 2 provides more flexibility compared to Option 1. It's useful when you want to capture all the available "external" port numbers, regardless of their position in the `ports` list. If the data structure changes in the future or varies between containers, Option 2 is more resilient.

### Step 3: Combining IP Addresses and Ports

```hcl
> [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
# Output:
[
 "172.17.0.3:32771",
 "172.17.0.2:32770",
]
```

This provides a clear output of IP address and external port for each container.

## Conclusion

This lesson has explored the power and functionality of for expressions in Terraform. By understanding how to utilize these expressions properly, you can achieve more concise and readable code. Feel free to play around with these examples to deepen your understanding.

## References

- [Terraform For Expressions Documentation](https://www.terraform.io/docs/language/expressions/for.html)
- [Docker Provider in Terraform](https://registry.terraform.io/providers/hashicorp/docker/latest/docs)