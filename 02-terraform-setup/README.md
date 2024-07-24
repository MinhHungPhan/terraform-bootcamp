# Terraform Setup

This README provides a step-by-step guide on setting up the Terraform configuration.

## Table of Contents

- [Pre-requisites](#pre-requisites)
- [Setup Instructions](#setup-instructions)
- [Conclusion](#conclusion)
- [References](#references)

## Pre-requisites

1. Git should be installed on your machine.
2. Bash shell should be installed on your machine.
3. Terraform should be installed on your machine.

If you don't have Terraform installed, we will go through the installation steps in this guide.

## Setup Instructions

### Step 1: Run the setup_git.sh bash script

First, create the `setup_git.sh` bash script using a text editor of your choice. This script will set up your Git credentials, cache them for 1 hour and set your username and email in the global Git configuration. Copy the following into your `setup_git.sh` file:

```bash
#!/bin/bash

# Set Git credential helper cache
git config --global credential.helper cache

# Set Git credential helper cache timeout to 1 hour
git config --global credential.helper 'cache --timeout=3600'

# Set Git user name
git config --global user.name "Minh Hung Phan"

# Set Git user email
git config --global user.email "minhhung.phan2701@gmail.com"
```

Save the file and make it executable with the following command:

```bash
chmod +x setup_git.sh
```

Now you can run the script:

```bash
./setup_git.sh
```

> **Note**: To locate the `setup_git.sh` file, navigate to the following [directory](/02-terraform-setup/scripts/setup_git.sh)

### Step 2: Run the install_terraform.sh bash script

First, create the `install_terraform.sh` bash script. This script should contain the commands necessary to install Terraform on your machine. Once the script is created and populated, make it executable with the following command:

```bash
chmod +x install_terraform.sh
```

Now you can run the script:

```bash
./install_terraform.sh
```

> **Note**: To locate the `install_terraform` file, navigate to the following [directory](/02-terraform-setup/scripts/install_terraform.sh)

### Step 3: Run Terraform

Now you are ready to run Terraform. Initialize your Terraform configuration with the following command:

```bash
terraform init
```

## Conclusion

Congratulations! You have set up your Terraform configuration. Now you can use the `terraform` command to plan and apply your infrastructure changes.

## References

- [Terraform Docs Overview](https://developer.hashicorp.com/terraform/docs)
- [Terraform Installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)