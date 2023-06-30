# Terraform Plan and Apply - Deep Dive

## Table of Contents

- [Introduction](#introduction)
- [Terraform Plan and Apply Commands](#terraform-plan-and-apply-commands)
- [Terraform Destroy Command](#terraform-destroy-command)
- [Understanding the Plan File](#understanding-the-plan-file)
- [Using Plan with Apply](#using-plan-with-apply)
- [Additional Command Options](#additional-command-options)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to the next part of our tutorial series! In this guide, we will build upon the knowledge you gained from the previous tutorial, ["Your First Terraform Apply"](/03-terraform-docker/02-basics-of-terraform/03-your-first-terraform-apply/README.md). We aim to provide you with a deeper understanding of essential Terraform commands, specifically focusing on `terraform plan` and `terraform apply`. By the end of this tutorial, you will have a practical understanding of how to create, update, and destroy your infrastructure using these powerful commands. Let's dive in and explore the functionalities of Terraform in more detail.

## Terraform Plan and Apply Commands

Let's begin by discussing `terraform plan` and `terraform apply`. These are crucial commands that allow us to create and update our infrastructure. 

In case our infrastructure has already been deployed, executing `terraform plan` will show us that the infrastructure is up-to-date, meaning no changes are needed.

For example:

```bash
terraform plan
```

Output:

```plaintext
No changes. Your infrastructure matches the configuration.
Terraform has compared your real infrastructure against your configuration and found no differences, so no changes
are needed.
```

The infrastructure is currently up to date, indicating that no changes are planned or required.

To check the available Docker images, execute the following command:

```bash
docker image ls
```

The output will display a list of images, including the nodered/node-red image:

```plaintext
REPOSITORY         TAG       IMAGE ID       CREATED        SIZE
nodered/node-red   latest    a15fc0f4e930   8 months ago   475MB
```

This confirms that the nodered image is currently accessible and ready for use.

## Terraform Destroy Command

In order to observe the `plan` command's output when changes are required, let's first destroy our existing infrastructure using the `terraform destroy` command. This will allow us to recreate it and better understand the process.

For example:

```bash
terraform destroy
```

When prompted to confirm the destruction of resources, type `yes`.

Output:

```plaintext
Destroy complete! Resources: 1 destroyed.
```

To confirm the deletion of the image, execute the following command:

```bash
docker image ls
```

After completion, the image will no longer appear in the output:

```plaintext
REPOSITORY         TAG       IMAGE ID       CREATED        SIZE
```

This confirms that the image has been successfully removed.

## Understanding the Plan File

Now, let's proceed with executing another Terraform plan.

```bash
terraform plan
```

Upon examination, the plan indicates the creation of a new resource. However, it's worth noting that I haven't specified an "out" parameter.

```plaintext
Plan: 1 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Please note that since the "out" option was not used to save this plan, executing "terraform apply" immediately may not guarantee the exact actions outlined in the plan.
```

Next, we can create a new plan by executing `terraform plan -out=plan1`. 

```bash
terraform plan -out=plan1
```

This command will create a plan named 'plan1', which is a file where Terraform writes the actions that `terraform apply` will execute.

_**Note**: This plan file is not human-readable, but rather an encoded file that should be handled carefully, especially when sensitive data is involved._

## Using Plan with Apply

One of the benefits of using a plan file is that it can be used with the `terraform apply` command for smoother automation. When `terraform apply` is run with a plan file, the confirmation step is skipped, making it ideal for automation but risky for manual operations.

For example:

```bash
terraform apply plan1
```

Output:

```plaintext
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## Additional Command Options

Both `terraform plan` and `terraform apply` have additional options which can be useful based on your needs. For instance, you can utilize the `-destroy` flag with `terraform plan` to simulate a `terraform destroy` command.

To explore these additional options, you can use:

```bash
terraform plan --help
terraform apply --help
```

Let's examine the output of the Terraform destroy command to see what the `terraform plan -destroy` entails. 

```bash
terraform plan -destroy
```

It is quite apparent that it specifies the destruction of the mentioned resources.

Output:

```js
Terraform will perform the following actions:


 # docker_image.nodered_image will be destroyed
 - resource "docker_image" "nodered_image" {
     - id          = "sha256:a15fc0f4e93018b7b6633639139a6fc1c6e13ca9275a6825cbecb6a4d2a85c57nodered/node-red:latest" -> null
     - latest      = "sha256:a15fc0f4e93018b7b6633639139a6fc1c6e13ca9275a6825cbecb6a4d2a85c57" -> null
     - name        = "nodered/node-red:latest" -> null
     - repo_digest = "nodered/node-red@sha256:524316b9b84cb5bbfe006c117f3dad31ee806804b12e4b866047a65e2080e92d" -> null
   }


Plan: 0 to add, 0 to change, 1 to destroy.
```

The above output clearly shows that the Terraform destroy command will result in the destruction of the specified resource, namely `docker_image.nodered_image`. The relevant attributes are listed, and the plan summary indicates that there will be no additions or changes, but one resource will be destroyed.

## Conclusion

This tutorial introduced the `terraform plan` and `terraform apply` commands and their interactions. We have also examined the `terraform destroy` command and the benefits of utilizing a plan file.

Keep in mind the importance of always checking the changes to be made before running terraform apply, especially when not using a plan file. Happy Terraforming!

## References

- [Terraform Plan](https://developer.hashicorp.com/terraform/cli/commands/plan)
- [Terraform Apply](https://developer.hashicorp.com/terraform/cli/commands/apply)
- [Terraform Destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy)