# Terraform State Deep Dive

## Table of Contents

- [Introduction](#introduction)
- [Understanding Terraform State](#understanding-terraform-state)
- [Working with Terraform State](#working-with-terraform-state)
- [Accessing State Data](#accessing-state-data)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome back! This tutorial is designed to delve deeper into the concept of Terraform state management. This is essential knowledge for anyone who wants to understand how Terraform tracks and manages the resources that it deploys. 

In this lesson, we'll explore what Terraform state is, how it operates, and how you can interact with it. We'll also see some examples of how it looks and behaves in a live environment.

## Understanding Terraform State

Terraform state is a JSON file that acts as a snapshot of your resources at a given point in time. It contains a comprehensive description of all the resources you have deployed. This is created after you run the command `terraform apply`. 

Inside the state, you can observe multiple important components. For example, the `version` indicates the version of Terraform being used, the `serial` is updated every time a resource or anything within the state is modified, and the `lineage` is created when the state file is originally created to verify its originality.

You can also see the metadata of everything you've deployed such as the IP address of Docker container, networking mode, the external/internal ports, and more.

## Working with Terraform State

When you run `terraform destroy` followed by `terraform apply`, it modifies the state by deleting all resources and then creates a new state file. Alongside this, it creates a `terraform.tfstate.backup` file that contains the previous state. This can be useful if you need to reference something from the previous state.

However, you should avoid directly accessing state files. They can contain sensitive information such as IP addresses, passwords, and variables. By default, the state is not encrypted but depending on the backend you use, it may be encrypted automatically.

```bash
terraform destroy -auto-approve
terraform apply -auto-approve
```

## Accessing State Data

To access state information in a safer manner, you can use `terraform show -json` and pipe it to the JQ command-line JSON processor. This allows you to view your state within the command-line interface (CLI) without directly accessing the state file.

1. Use the following command to install jq:

```bash
sudo apt install jq
```

2. To display the Terraform state in JSON format, run the following command:

```bash
terraform show -json | jq
```

The output will be similar to:

```js
{
 "format_version": "1.0"
}
```

3. To apply Terraform changes with auto-approval, execute the following command:

```bash
terraform apply -auto-approve
```

4. To view all the information in the Terraform state without accessing the file directly, use the following command:

```bash
terraform show -json | jq
```

Now you can see all the information in your state without having to access the file directly.

**Note**: Remember that anyone who has access to your console has access to all your state data. Manage your secrets properly!

For further interaction with your state, you can use the `terraform state list` command to display all the resources within your state. This can be helpful for troubleshooting, looking for variables, or trying to find ways to output different information.

```bash
terraform state list
```

Output:

```plaintext
docker_container.nodered_container
docker_image.nodered_image
```
## Conclusion

We've explored the ins and outs of Terraform state in this tutorial, covering everything from the basic concepts to the actual usage. With this knowledge, you should be well-equipped to manage and interact with the state of your Terraform deployments. Be sure to join us in the next lesson as we continue exploring more Terraform features!

## References

- [HashiCorp Terraform - Terraform State](https://developer.hashicorp.com/terraform/language/state)