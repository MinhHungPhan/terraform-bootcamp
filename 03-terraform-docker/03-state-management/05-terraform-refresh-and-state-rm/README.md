# Terraform `refresh` and `state rm` Commands

Welcome to this guide on understanding Terraform's `refresh` and `state` commands, as well as how they impact the state and your existing resources.

## Table of Contents

- [Introduction](#introduction)
- [Setup](#setup)
- [Exploring `terraform refresh`](#exploring-terraform-refresh)
- [Managing Terraform State](#managing-terraform-state)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Terraform is a powerful infrastructure-as-code tool. As you work with Terraform, it's crucial to know how commands like `refresh` and `state` work, especially since they can directly manipulate and display the state of your resources.

## Setup

Before diving deep, let's ensure we're all starting from the same point:

1. If you have not done so, clear your resources with:

```bash
terraform destroy --auto-approve
```

2. Ensure your count for your random string and Docker container is set to one.

```hcl
resource "random_string" "random" {
  count   = 1
  length  = 4
  special = false
  upper   = false
}
```

3. Apply your configurations:

```bash
terraform apply --auto-approve
```

Your setup should now be complete and ready for further actions.

## Exploring `terraform refresh`

### Displaying Current State

You can view your current Terraform state with:

```bash
terraform state list
```

### Modifying Outputs and Refreshing

Changing an output in Terraform doesn't alter the actual resource in your infrastructure; it only updates the state file. For instance, consider a scenario where you update the name of the `nodered_container` resource:

```hcl
resource "docker_container" "nodered_container" {
 count = 1
 name  = join("-",["nodereeeed",random_string.random[count.index].result])
 image = docker_image.nodered_image.latest
 ports {
   internal = 1880
   # external = 1880
 }
}
```

Now, let's run the following command:

```bash
terraform refresh
```

⚠️ **Warning: `terraform refresh` is deprecated**

HashiCorp no longer recommends using `terraform refresh`, as Terraform automatically updates the state during `terraform plan` and `terraform apply`. Instead, use:

```bash
terraform plan -refresh-only
```

or

```bash
terraform apply -refresh-only
```

to safely update the state without modifying infrastructure.

---

🎯 **Example Output**:

```bash
╷
│ Warning: The terraform refresh command is deprecated
│ 
│ The "terraform refresh" command is no longer needed because Terraform now
│ automatically updates state during normal operations. Removing this command
│ helps to avoid confusion about when it should be used. To update the state,
│ use "terraform apply" or "terraform plan -refresh-only".
╵

Refreshing Terraform state in-memory prior to plan...

docker_container.nodered_container[0]: Refreshing state... [id=a1b2c3d4e5f6]
```

This confirms that Terraform updated the state with the latest data from the actual infrastructure.

To observe this distinction, you can use `terraform output` to review the outputs:

```bash
terraform output
```

🎯 **Example Output**:

```bash
Container-name = [
  "nodereeeed-3pf1"
]
IP-Address = [
  "172.17.0.2:32785"
]
```

This confirms that the Terraform output has been updated, but the actual container in Docker remains unchanged.

To inspect the state of your resources, use:

```bash
terraform state list
```

🎯 **Example Output**:

```bash
docker_container.nodered_container[0]
docker_container.nodered_container2
docker_image.nodered_image
random_string.random[0]
```

This lists all resources currently tracked in the Terraform state.

💡 **Explanation**:

- `docker_container.nodered_container[0]`:
  - This represents the first instance of the `docker_container` resource named `nodered_container`.
  - The `[0]` indicates that this is the first (and in this case, only) instance in a list, as the `count` parameter is set to 1 in the `main.tf` file.
- `docker_container.nodered_container2`
  - This represents another `docker_container` resource named `nodered_container2`.
  - Unlike `nodered_container`, this resource does not use the `count` parameter and is a standalone resource.

---

By using `terraform plan -refresh-only`, we update the Terraform state file without modifying the actual infrastructure. This approach is more reliable and recommended by HashiCorp.

### Resource Changes and Refresh Behavior

It's important to note that certain changes, like the length of a random string, might require a new resource creation. Running `terraform refresh` in these cases won't make a visible change.

For instance, consider this resource modification:

```hcl
resource "random_string" "random" {
  count   = 1
  length  = 5
  special = false
  upper   = false
}
```

### Targeting Specific Resources

Terraform allows you to target specific resources during a refresh:

```bash
terraform refresh -target=random_string.random
```

## Managing Terraform State

### Syncing State with Infrastructure

If there's a mismatch between your actual infrastructure and the Terraform state (e.g., a container was deleted outside of Terraform), use:

```bash
terraform refresh
```

This command updates the state file to match the real infrastructure. However, note that it doesn't update the output.

### Manually Modifying State

In exceptional cases, you may need to remove items from the state. You can do this with:

```bash
terraform state rm <resource_type.resource_name>
```

Remember, manually manipulating state is risky and should only be done in emergencies. Terraform will generate a backup of the state every time you use the `state rm` command.

## Conclusion

This guide explored the `refresh` and `state` commands in Terraform. While these are powerful tools, always exercise caution, especially with manual state manipulations. Regularly reviewing and practicing these concepts ensures your infrastructure management remains smooth and error-free.

Thank you for following along! Ensure to run `terraform destroy` if needed, and we look forward to guiding you in the next lesson!

## References

- [Terraform Refresh Documentation](https://developer.hashicorp.com/terraform/cli/commands/refresh)
- [Terraform state rm command Documentation](https://developer.hashicorp.com/terraform/cli/commands/state/rm)

