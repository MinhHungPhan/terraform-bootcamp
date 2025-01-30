# Terraform State Locking

## Table of Contents

- [Introduction](#introduction)
- [Unlocked State in Terraform](#unlocked-state-in-terraform)
- [Demonstration Setup](#demonstration-setup)
- [Using `random_string` Resource](#using-random_string-resource)
- [Executing the Unlocked Terraform Apply](#executing-the-unlocked-terraform-apply)
- [Observing the Results](#observing-the-results)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

Welcome to this lesson where we delve into the intricacies of Terraform state management. Today, we're going to explore a crucial concept in Terraform — state locking — and see the ramifications of an unlocked state.

## Unlocked State in Terraform

In single engineer deployments, it might seem unlikely to encounter concurrent Terraform deployments. However, in larger production settings, simultaneous deployments can and do happen, leading to potential issues. Let's find out what happens when a Terraform state file becomes unlocked and two deployments are triggered simultaneously.

## Demonstration Setup

1. **Initiate Two Terminals**: Open two terminal windows. Ensure you're logged into the appropriate account.

2. **Prep First Terminal**:

```bash
terraform destroy --auto-approve
cd terraform-docker
```

3. **Prep Second Terminal**: Similarly, change into the `terraform-docker` directory.

4. **Arrange Terminals**: For easy visibility, adjust both terminal windows so you can access them simultaneously. You can have a split-screen configuration or stack them vertically.

## Using `random_string` Resource

### **Step 1: Generate a Random String**

The following Terraform resource generates a **random string** to be used as part of the container name.

```hcl
resource "random_string" "random" {
  count   = 1
  length  = 4
  special = false
  upper   = false
}
```

### **How It Works:**

- Generates a **4-character long** string.
- No special characters (`special = false`).
- Only lowercase letters (`upper = false`).
- `count = 1` ensures **only one** random string is created.

### **Example Output:**

If Terraform generates `"ab12"`, then:

```hcl
random_string.random[0].result = "ab12"
```

## **Step 2: Create a Docker Container**

Terraform then creates a **Docker container** using the randomly generated string for a unique name.

```hcl
resource "docker_container" "nodered_container" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = 1880
    # external = 1880
  }
}
```

### **How It Works:**

- `count = 1`: Creates **one container**.
- `name = join("-", ["nodered", random_string.random[count.index].result])`:
    - Combines `"nodered"` with the random string.
    - Example: `"nodered-ab12"`.
- `image = docker_image.nodered_image.latest`: Uses the **Node-RED** Docker image.
- `ports { internal = 1880 }`: 
    - The container exposes **port 1880 internally** (used by Node-RED).
    - The external port is commented out (`# external = 1880`), meaning the container **does not expose port 1880 to the host**.

## **Step 3: Understanding `count.index` and `.result`**

### **Why Use `count.index`?**

```hcl
random_string.random[count.index].result
```

Terraform treats resources with `count` as **arrays**, even if `count = 1`.  

- `count.index` represents **the index of the resource being created** (starting from `0`).
- Since `random_string.random` is an array, we must specify `[count.index]` to access its elements.

📌 **Without `count.index`, Terraform would not know which random string to use.**  

If `count = 3`, the references would be:

```
random_string.random[0].result  # First container
random_string.random[1].result  # Second container
random_string.random[2].result  # Third container
```

**Final Analogy – Think of `count.index` Like a For-Loop**

Terraform doesn’t use a traditional programming loop, but **you can think of `count` as working like this pseudo-code:**

```python
for index in range(3):  # Simulates Terraform count = 3
    print(f"Creating Server {index}")  # Simulates count.index
```

**Output:**

```plaintext
Creating Server 0
Creating Server 1
Creating Server 2
```

✅ **Terraform automatically assigns `count.index` in the same way**.

### **Why `.result`?**

When Terraform creates a `random_string`, it stores multiple attributes inside an object.  

Example Terraform state:

```hcl
random_string.random[0] = {
  id      = "random_1234"
  length  = 4
  lower   = true
  special = false
  upper   = false
  result  = "ab12"  # This is the actual random string
}
```

- `random_string.random[count.index]` is an **object** with multiple attributes.
- `.result` extracts **only the generated random string**.

**If you remove `.result`, Terraform will throw an error** because it will try to use an object instead of a string.

## Executing the Unlocked Terraform Apply

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
- [The count Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [random_string (Resource)](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)