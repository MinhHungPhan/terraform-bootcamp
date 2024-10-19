# Configuring Docker Compose for Terraform

Welcome to this guide on configuring Docker Compose for Terraform! This document aims to help you set up a clean, isolated environment for running Terraform using Docker Compose. By the end of this guide, you'll have a working setup that simplifies your Terraform workflow and makes your infrastructure-as-code practice more efficient.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setting Up Terraform with Docker Compose](#setting-up-terraform-with-docker-compose)
    - [Step 1: Creating `.gitignore` for Terraform Project](#step-1-creating-gitignore-for-terraform-project)
    - [Step 2: Creating the `infra` Directory](#step-2-creating-the-infra-directory)
    - [Step 3: Defining the `docker-compose.yml`](#step-3-defining-the-docker-composeyml)
- [Best Practices](#best-practices)
- [Key Takeaways](#key-takeaways)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Terraform is a powerful tool for managing infrastructure, and Docker Compose offers a simple way to containerize and isolate dependencies. Combining these tools allows you to run Terraform in a consistent and repeatable environment, improving productivity and reducing the likelihood of "it works on my machine" issues.

## Prerequisites

Before you start, make sure you have:
- [Docker](https://docs.docker.com/get-docker/) installed on your machine.
- [Docker Compose](https://docs.docker.com/compose/install/) installed.
- Basic understanding of Docker, Docker Compose, and Terraform.

## Setting Up Terraform with Docker Compose

### Step 1: Creating `.gitignore` for Terraform Project

To avoid committing sensitive or unnecessary files, include the following `.gitignore` in your project:

```bash
# Local Terraform state
*.tfstate
*.tfstate.backup

# Crash log files
crash.log

# Exclude .terraform directory
.terraform/

# Sensitive variable files
*.tfvars
*.tfvars.json

# Lock file
.terraform.lock.hcl

# Ignore override files as they are usually used to override resources locally and should not be part of version control
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Ignore CLI configuration files
.terraformrc
terraform.rc

# Ignore any plan files
*.tfplan

# Ignore any generated files
*.tfvars.generated

# Ignore any temporary files
*.tmp
*.temp
```

### Step 2: Creating the `infra` Directory

We’ll start by creating a dedicated directory to organize all infrastructure-related files.

1. **Create the `infra` Directory**:

```bash
mkdir infra
cd infra
```

This directory will contain all necessary configuration files related to your Terraform and Docker setup, keeping your project organized.

### Step 3: Defining the `docker-compose.yml`

Now, create the `docker-compose.yml` file inside the `infra` directory:

```yaml
services:
  terraform:
    image: hashicorp/terraform:latest
    container_name: terraform-container
    volumes:
      - ./setup:/terraform/setup
      - ./deploy:/terraform/deploy
    working_dir: /terraform
    environment:
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}
      - AWS_DEFAULT_REGION=us-east-1
      - TF_WORKSPACE=${TF_WORKSPACE}
```

The `docker-compose.yml` file serves as the blueprint for defining and orchestrating the Docker container for Terraform. In this file, we specify the Docker image, container settings, environment variables, and volume mappings that help us maintain a clean and consistent environment for running Terraform commands.

Here’s the breakdown of what this configuration does:

1. **Service Definition (`services`)**: This defines a service named `terraform` using the official Terraform Docker image (`hashicorp/terraform:latest`).

2. **Volume Mappings**: 

- The configuration maps the local `./setup` and `./deploy` directories to the corresponding paths inside the container. This approach separates different stages of Terraform configuration files, such as `setup` for initial infrastructure setup and `deploy` for resource deployments. It keeps the project structured and organized.

3. **Working Directory (`working_dir`)**: Sets the default working directory inside the container to `/terraform`, ensuring all Terraform commands are run from a specific, consistent path.

4. **Environment Variables**: 

- Passes crucial AWS credentials and configuration details (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN`) securely from the host environment. This practice eliminates hardcoding sensitive information inside the Docker Compose file.
- Sets the AWS region to `us-east-1`, which can be customized based on your needs.
- Configures the Terraform workspace using the `TF_WORKSPACE` environment variable, enabling users to switch between multiple workspaces easily.

## Best Practices

- **Use Environment Variables**: Pass sensitive values, such as API keys, using environment variables in `docker-compose.yml` instead of hardcoding them.
- **Leverage Volumes**: Always use volumes to persist Terraform state files (`.tfstate`) on your local machine to prevent data loss.
- **Version Control**: Keep your Docker Compose file under version control to maintain consistency across environments.
- **Security Considerations**: Regularly update the base Terraform image and review security best practices to avoid vulnerabilities.

## Key Takeaways

- Docker Compose offers an easy way to containerize Terraform, ensuring consistency and reproducibility.
- Leveraging volumes helps you persist important files like state files and configuration files.
- Best practices such as using environment variables and version control improve security and maintainability.

## Conclusion

Congratulations! You have successfully configured Docker Compose to work with Terraform. This setup provides a reliable and consistent environment for managing your infrastructure using Terraform, minimizing local dependency issues and enabling seamless collaboration.

## References

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Deploy Terraform Enterprise to Docker](https://developer.hashicorp.com/terraform/enterprise/deploy/docker)