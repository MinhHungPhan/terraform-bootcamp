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

## Observing the Results

When you apply this Terraform configuration, you’ll see both commands execute successfully. In typical scenarios, **simultaneous deployments might lead to conflicts or collisions**. However, by using the `random_string` resource, the containers are named **uniquely**, preventing name conflicts.

### **Step 1: Inspect Terraform State**

To verify what Terraform is managing, inspect the state using:

```bash
terraform state list
```

**Expected Outcome**:

- You may find **only one container recorded** in the Terraform state.
- Even if two deployments were attempted, **only one container may be registered** in the state.

### **Step 2: Verify Details with `terraform show`**

To view the full details of the Terraform state, including resource attributes, run:

```bash
terraform show
```

**Expected Outcome**:

- This will confirm the previous observation.
- If you search for a missing container, you **won’t find it in the state**.

### **Step 3: List All Running Docker Containers**

Even if Terraform doesn't track all deployments, the containers still exist in Docker. You can verify by running:

```bash
docker ps -a
```

**Expected Outcome**:

- Both containers will be listed with their unique names (e.g., `nodered-ab12`).
- However, Terraform may **only recognize one of them** in its state.

### **Step 4: Destroy Resources with `terraform destroy`**

Now, try to destroy all Terraform-managed resources:

```bash
terraform destroy --auto-approve
```

**Potential Error**:

Because Terraform's state **does not include all running containers**, it may fail to properly remove the Docker images, resulting in this error:

```plaintext
Error: Unable to remove Docker image: Error response from daemon: conflict: unable to delete d443beaad565 (cannot be forced) - image is being used by running container 9f74026f9af6
```

**Why Does This Error Occur?**:

- Terraform tries to remove the **Docker image (`d443beaad565`)**, but **a running container (`9f74026f9af6`) is still using it**.
- Since the container exists **outside Terraform's state**, Terraform does not automatically stop it before removing the image.

## Conclusion

The lesson underscores the importance of Terraform's state locking mechanism. While it might seem enticing to run multiple deployments simultaneously, doing so without appropriate safeguards can lead to conflicts and inconsistencies. Always ensure the state is locked during critical operations to avoid these complications.

In our next lesson, we'll explore ways to rectify such issues and maintain a consistent Terraform state.

## References

- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)
- [Terraform State Locking](https://developer.hashicorp.com/terraform/language/state)
