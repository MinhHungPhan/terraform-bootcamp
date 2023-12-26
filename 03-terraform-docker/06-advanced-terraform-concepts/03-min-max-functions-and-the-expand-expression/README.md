# Min and Max Functions and Expand Expression

## Table of Contents

- [Introduction](#introduction)
- [Understanding Min and Max Functions](#understanding-min-and-max-functions)
- [The Expand Expression](#the-expand-expression)
- [Practical Examples](#practical-examples)
- [Hands-On](#hands-on)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to the comprehensive guide on using Min and Max functions and the Expand expression in Terraform. This document aims to provide a clear understanding of these tools, enhancing your infrastructure coding in Terraform. Whether you're configuring ports, validating rules, or managing lists, this guide will walk you through practical applications and examples.

## Understanding Min and Max Functions

**Min Function:** This function is used to find the minimum value among given numbers. It's particularly useful in settings where you need to establish lower bounds.

**Max Function:** Similar to Min, the Max function is used to identify the maximum value from a set of numbers. It’s essential for defining upper limits.

Both functions play a crucial role in ensuring that configurations, such as port numbers, stay within desired ranges.

## The Expand Expression

The Expand expression, often known as a spread operator in other languages like JavaScript, is vital for handling lists. It allows you to expand list items into individual elements, making them compatible with functions like Min and Max, which expect separate numerical arguments.

**Expanding Function Arguments**

When function arguments are in a list or tuple, they can be expanded into separate arguments using the `...` symbol:

```terraform
# Using expand expression with the Min function
min_value = min([10, 20, 30]...)
# Output: 10
```

*Note: The expansion symbol is three periods (`...`), not a Unicode ellipsis character (`…`). This special syntax is only available in function calls.*

## Practical Examples

**Example 1: Using Max Function**

```terraform
# Find the maximum value from a list
max_value = max(10, 20, 30)
# Output: 30
```

**Example 2: Using Min Function with Expand Expression**

```terraform
# Define a list
port_list = [10, 20, 30]

# Find the minimum value using the expand expression
min_port = min(...port_list)
# Output: 10
```

These examples show how you can use these functions to enforce rules, like ensuring port numbers are within a specific range.

## Hands-On

**Configuring `variables.tf`**

This practice demonstrates the application of Min and Max functions in a Terraform variable definition.

```hcl
variable "ext_port" {
  type        = list
  sensitive   = true
  default     = [76423]
  validation {
    condition     = max(var.ext_port...) <= 65535 && min(var.ext_port...) > 0
    error_message = "The external port must be in the valid range 0 - 65535."
  }
}
```

In this configuration, `ext_port` is a list of port numbers. The validation rule uses both Min and Max functions to ensure that every port number in the list falls within the valid range of 0 - 65535.

## Conclusion

This guide provided an insight into the Min and Max functions and the Expand expression in Terraform. Understanding these tools is crucial for effective infrastructure coding, allowing you to set bounds and handle lists efficiently.

## References

- [Terraform Min Function](https://developer.hashicorp.com/terraform/language/functions/min)
- [Terraform Max Function](https://developer.hashicorp.com/terraform/language/functions/max)
- [Terraform Expand Expression](https://developer.hashicorp.com/terraform/language/expressions/function-calls#expanding-function-arguments)