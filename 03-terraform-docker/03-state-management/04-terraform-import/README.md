# Terraform Import

Welcome to this guide on managing and fixing the state of your Terraform deployments. Here, we will tackle the intricacies of state-locking, the importance of correcting corrupted states, and demonstrate the powerful `terraform import` command that aids in rectifying mistakes. Especially for those new to Terraform, understanding the state can be a game-changer.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Understanding the Issue](#understanding-the-issue)
- [Importing Resources](#importing-resources)
- [Cleaning Up](#cleaning-up)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

[In the previous lesson](/03-terraform-docker/03-state-management/03-terraform-state-locking/README.md), we delved into state-locking and saw how it can be intentionally broken. Now, we'll understand how to mend the broken state.

## Prerequisites

If you missed the previous lesson or are reviewing certain segments, you need to reset to the state of the last lesson:
1. Set count resources to one.
2. Execute the commands below in two terminal windows, running them as simultaneously as possible:

```bash
terraform apply --auto-approve --lock=false
```
And in the other terminal:

```bash
terraform apply --auto-approve
```

This procedure will generate two resources; one will be present in the state, while the other will be absent.

## Understanding the Issue

Upon executing the aforementioned commands, if you check your Terraform state and your actual containers, you'll notice a disparity:

```bash
terraform state list
```

You may see that while you have two containers running, only one is tracked by the Terraform state. The untracked container presents an issue; Terraform will be unable to manage or delete it, leading to a corrupted state.

## Importing Resources

The `terraform import` command can be an invaluable tool when faced with such state inconsistencies.

1. First, let's get the `container_name` that is not referenced in the state:

```bash
terraform output
```

2. First, let's add the errant Docker container to our Terraform configuration (`main.tf`):

```hcl
resource "docker_container" "nodered_container2" {
  name  = "[container_name]"
  image = docker_image.nodered_image.latest
}
```

**Note**: Enter the `container_name` that is not tracked by the state file using the `terraform output` in the previous step. For example: `nodered-3pf1`.

3. Obtain the ID of the Docker container that isn't in the state:

```bash
docker inspect --format="{{.ID}}" [container_name]
```

4. With this ID, you can now import the Docker container into the Terraform state:

```bash
terraform import docker_container.nodered_container2 $(docker inspect --format="{{.ID}}" [container_name])
```

After importing, you can verify its addition by checking the Terraform state again.

## Cleaning Up

Once the state inconsistencies are resolved, you can safely destroy your entire deployment:

```bash
terraform destroy --auto-approve
```

For those who wish to bypass these steps and simply want to remove leftover resources post-Terraform destruction, you can resort to Docker commands:

1. Destroy resources via Terraform:

```bash
terraform destroy
```

2. Remove any lingering Docker containers:

```bash
docker rm -f [container_name]
```

3. Re-run the Terraform destroy command to ensure all resources have been terminated.

## Conclusion

Handling Terraform's state can be challenging, but understanding its quirks and having the tools to correct issues can be invaluable. The `terraform import` command provides a safety net for scenarios where state discrepancies occur. Experimenting with and mastering this can prove invaluable, especially in complex, production-grade environments.

## References

- [Terraform State Import Tutorial](https://developer.hashicorp.com/terraform/tutorials/state/state-import)
- [Terraform CLI Import Guide](https://developer.hashicorp.com/terraform/cli/import)