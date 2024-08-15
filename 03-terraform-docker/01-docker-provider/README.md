# Terraform with Docker Provider

## Table of Contents

- [Introduction](#introduction)
- [Understanding Providers in Terraform](#understanding-providers-in-terraform)
- [Creating a New Directory](#creating-a-new-directory)
- [Setting up Docker Provider](#setting-up-docker-provider)
- [Running Terraform](#running-terraform)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Hello, and welcome to our Terraform tutorial. This guide is designed to help you grasp the basics of Terraform and simplify its usage. You will learn about providers in Terraform, with a focus on Docker, and how to script and deploy using this infrastructure as code tool. For beginners, don't worry about the complexity; this guide will make it easy to understand Terraform and its features, even if you've never encountered it before.

## Understanding Providers in Terraform

Terraform uses the concept of "providers" as a kind of bridge between the platform and its resources. A provider, essentially, is an abstract representation of a resource's API. They can interact with anything that offers an API - cloud providers like Google and Azure, infrastructure providers like VMware or Docker, and even applications like Domino's Pizza which, surprisingly, had a Terraform provider at one point for ordering pizza.

## Creating a New Directory

Before we begin writing our Terraform script, we first need to set up our workspace. We will create a new directory specifically for our Terraform code. This directory can be named as per your preference. For the purpose of this guide, we'll call it "terraform-docker."

```bash
mkdir terraform-docker
```

Within this new directory, we will create a main Terraform file (`.tf`). Naming conventions suggest using `main.tf`, but this is not mandatory; the file could be named anything as long as it ends with `.tf`. Terraform runs all `.tf` files in the directory as if they were a single file.

```bash
cd terraform-docker
touch main.tf
```

## Setting up Docker Provider

Setting up the Docker provider is the next step. We'll use a Docker provider from a third-party company, and the latest version at the time of this guide is `2.15.0`. We will create a Terraform block, which will include our required providers - in this case, Docker. 

The configuration of the Docker provider can be customized as per your needs. For instance, if you're using a remote server to run your Docker commands, you can specify the host's location. However, for our local setup, we won't need any specific configuration details.

You can setup the Docker provider using the following `main.tf` file:

```hcl
terraform {
 required_providers {
   docker = {
     source = "kreuzwerker/docker"
   }
 }
}

provider "docker" {}
```

## Running Terraform

Once the Docker provider is set up, we can run Terraform to ensure everything is correctly initialized using the following command: 

```bash
terraform init
```

If everything has been set up correctly, you should receive a message stating that Terraform has been successfully initialized. 

## Conclusion

Now that we've covered the basics of using Docker with Terraform, you can start deploying your infrastructure. Remember, the process may seem complex at first, but with practice, you'll find that using Terraform is an efficient and powerful tool for managing your infrastructure.

## References

- [Docker Provider](https://developer.hashicorp.com/terraform/docs)
- [HashiCorp. (2022). Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Docker. (2022). Docker Provider Documentation](https://www.terraform.io/docs/providers/docker/index.html)

  
