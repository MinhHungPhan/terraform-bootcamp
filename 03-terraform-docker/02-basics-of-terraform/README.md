# Basics of Terraform

Welcome to the Basics of Terraform course! This repository will help you get started with Terraform, focusing on core concepts and practical steps to manage infrastructure as code effectively. Whether you're a beginner or looking to solidify your Terraform skills, this course has you covered.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Sub-directories Overview](#sub-directories-overview)
    - [Terraform Init Deeper Dive](#terraform-init-deeper-dive)
    - [Terraform Dependency Lock](#terraform-dependency-lock)
    - [Your First Terraform Apply](#your-first-terraform-apply)
    - [Terraform Plan and Apply Deeper Dive](#terraform-plan-and-apply-deeper-dive)
    - [Deploying Docker Container](#deploying-docker-container)
- [Support](#support)
- [Conclusion](#conclusion)

## Introduction

Welcome to the **Basics of Terraform** course! This course is designed to provide you with a solid foundation in Terraform, focusing on the core concepts and workflows that are essential for managing infrastructure as code. Through a series of modules, you will learn how to initialize a Terraform environment, manage dependencies, apply configurations, and deploy Docker containers using Terraform.

## Sub-directories Overview

### [Terraform Init Deeper Dive](01-terraform-init-deeper-dive/README.md)

This module provides a deeper dive into the `terraform init` command. You will learn how to initialize a Terraform working directory, understand the purpose of the `.terraform` directory, and explore backend configurations. By the end of this module, you will have a comprehensive understanding of the initialization process.

### [Terraform Dependency Lock](02-terraform-dependency-lock/README.md)

In this module, you will learn about Terraform's dependency lock file, `terraform.lock.hcl`. This module covers how Terraform manages provider versions, ensures consistency across environments, and prevents potential issues caused by provider updates.

### [Your First Terraform Apply](03-your-first-terraform-apply/README.md)

This module guides you through your first `terraform apply` command. You will create a simple Terraform configuration to deploy resources, understand the output of the apply command, and learn how to manage the Terraform state file.

### [Terraform Plan and Apply Deeper Dive](04-terraform-plan-and-apply-deeper-dive/README.md)

In this module, you'll take a closer look at the `terraform plan` and `terraform apply` commands. Learn how to create execution plans, review and interpret changes, and apply them to your infrastructure. This module also covers the use of flags and options to customize the behavior of these commands.

### [Deploying Docker Container](05-deploying-docker-container/README.md)

This final module demonstrates how to use Terraform to deploy a Docker container. You will learn how to define Docker resources, configure container settings, and use Terraform to manage the lifecycle of your Docker containers.

## Support

If you have any questions or need assistance, you can:
- Open an issue in the GitHub repository
- Contact the course maintainers via email at support@kientree.com
- Join our community Slack channel for real-time help

## Conclusion

Thank you for participating in the **Basics of Terraform** course! We encourage you to practice the concepts you've learned by revisiting the modules and experimenting with your own Terraform configurations. The more you practice, the more proficient you will become in managing infrastructure as code with Terraform. Happy learning! 🌱