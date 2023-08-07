# Terraform State Locking

## Table of Contents

- [Introduction](#introduction)
- [Unlocked State in Terraform](#unlocked-state-in-terraform)
    - [Demonstration Setup](#demonstration-setup)
    - [Executing the Unlocked Terraform Apply](#executing-the-unlocked-terraform-apply)
    - [Observing the Results](#observing-the-results)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this lesson where we delve into the intricacies of Terraform state management. Today, we're going to explore a crucial concept in Terraform — state locking — and see the ramifications of an unlocked state.

## Unlocked State in Terraform

In single engineer deployments, it might seem unlikely to encounter concurrent Terraform deployments. However, in larger production settings, simultaneous deployments can and do happen, leading to potential issues. Let's find out what happens when a Terraform state file becomes unlocked and two deployments are triggered simultaneously.

### Demonstration Setup

1. **Initiate Two Terminals**: Open two terminal windows. Ensure you're logged into the appropriate account.

2. **Prep First Terminal**:

```bash
terraform destroy --auto-approve
cd terraform-docker
```

3. **Prep Second Terminal**: Similarly, change into the `terraform-docker` directory.

4. **Arrange Terminals**: For easy visibility, adjust both terminal windows so you can access them simultaneously. You can have a split-screen configuration or stack them vertically.

### Executing the Unlocked Terraform Apply

1. **Inspect Plan**:

```bash
terraform plan
```
Ensure that the desired resources are set to be deployed.

2. **Set up Terraform Apply Commands**:

**Console 1**:

```bash
terraform apply --auto-approve -lock=false
```

**Console 2**:

```bash
terraform apply --auto-approve
```

3. **Execute Simultaneously**: Click `Enter` in the first terminal, followed immediately by the second. Watch as both commands execute concurrently.

### Observing the Results

You'll observe both commands applying. In typical scenarios, simultaneous deployments might lead to conflicts or collisions. But, because of the use of the `random` resource, the containers are named differently.

On inspecting the state, you'll find:

- **Only one container in the state**: This means that even though both deployments ran, only one container's information got written to the state.

- **Verification with Terraform Show**:

```bash
terraform show
```

This will confirm the above observation. If you query for a missing container, you won't find it in the state.

- **View all Containers**:

```bash
docker -a
```

Both containers exist with their respective names, but not both are represented in the state.

Running `terraform destroy` after this will result in a conflict because the state does not have all the resources it needs. This shows the danger of an unlocked and imbalanced state.

## Conclusion

The lesson underscores the importance of Terraform's state locking mechanism. While it might seem enticing to run multiple deployments simultaneously, doing so without appropriate safeguards can lead to conflicts and inconsistencies. Always ensure the state is locked during critical operations to avoid these complications.

In our next lesson, we'll explore ways to rectify such issues and maintain a consistent Terraform state.

## References

- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)
- [Terraform State Locking](https://developer.hashicorp.com/terraform/language/state)
