# Implementing Bind Mount and Local Exec in Terraform

## Table of Contents

- [Introduction](#Introduction)
- [The Role of Bind Mounts in Persistence](#The-Role-of-Bind-Mounts-in-Persistence)
- [Utilizing Terraform's Local Exec](#Utilizing-Terraforms-Local-Exec)
- [Step-by-Step Implementation](#Step-by-Step-Implementation)
- [Overcoming Idempotence Challenges](#Overcoming-Idempotence-Challenges)
- [Configuring the Docker Volume Bind Mount](#Configuring-the-Docker-Volume-Bind-Mount)
- [Testing and Verification](#Testing-and-Verification)
- [Conclusion](#Conclusion)
- [References](#References)

## Introduction

This guide focuses on using Terraform to create a persistent environment for Node-Red by implementing bind mounts and the Local Exec provisioner.

## The Role of Bind Mounts in Persistence

Bind mounts play a crucial role in data persistence by linking a specific folder on the host machine to a directory in the Docker container. This method ensures data continuity for Node-Red across reboots and relaunches.

## Utilizing Terraform's Local Exec

Terraform's Local Exec provisioner is instrumental in executing local shell commands as part of your Terraform configuration. We use this to set up our bind mount for Node-Red.

## Step-by-Step Implementation

### Creating a Docker Volume Bind Mount

1. **Start Terraform Console**: Launch your Terraform environment.
2. **Implement Null Resource**: Use Terraform's `null_resource` to create a Docker volume:

```hcl
resource "null_resource" "dockervol" {

}
```

- **`null_resource`**: The `null_resource` is a special type of resource in Terraform that doesn't manage any actual infrastructure. It is often used for running provisioners or executing scripts without creating a physical resource.

- **`"dockervol"`**: This is the name of the `null_resource`. It is a logical identifier that you can reference elsewhere in your Terraform configuration.

### Setting Appropriate Permissions

Ensure the Docker volume has the necessary permissions as per Node-Red's requirements.

```hcl
resource "null_resource" "dockervol" {
    provisioner "local-exec" {
    command = "mkdir noderedvol/ && sudo chown -R 1000:1000 noderedvol/"
    }
}
```

- **`provisioner "local-exec"`**: The **`local-exec`** provisioner allows you to execute a local shell command on the machine where Terraform is running.

- **`command`**: The command being executed is:

```bash
mkdir noderedvol/ && sudo chown -R 1000:1000 noderedvol/
```

- **`mkdir noderedvol/`**: Creates a directory named `noderedvol` in the current working directory.
- **`sudo chown -R 1000:1000 noderedvol/`**: Changes the ownership of the `noderedvol` directory (and its contents, recursively) to the user and group with the ID `1000`. This is often used to set permissions for Docker containers, as many containers run processes with a specific user ID (e.g., `1000`).

## Overcoming Idempotence Challenges

To maintain Terraform's idempotent nature, add a logic check in the command script. This prevents errors on multiple executions.

- **Handle Idempotence**: To ensure Terraform scripts can be run multiple times without errors, add a condition to check if the directory already exists.

```hcl
command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
```

## Adding the Volume to Docker Container

- Use `pwd` to print the working directory, which gives you the full path to where you just created the directory. 

```bash
pwd
```

If you created a directory named `noderedvol` in the home directory of your Linux system, the path would typically be `/home/ubuntu/environment/terraform-docker/noderedvol`.

- **Attach the Volume**: Modify your Docker container resource to include the newly created volume.

```hcl
resource "docker_container" "node_red" {
    
    volumes {
    container_path = "/data"
    host_path      = "/home/ubuntu/environment/terraform-docker/noderedvol"
    }
}
```

## Configuring the Docker Volume Bind Mount

After setting up the volume, attach it to the Docker container using the bind mount technique. This step involves specifying the volume in the Docker container's resource block.

```hcl
resource "docker_container" "nodered_container" {
  count = var.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest

  ports {
    internal = var.int_port
    external = var.ext_port
  }
  
  # Attach the volume to the Docker container
  volumes {
    container_path = "/data"
    host_path      = "/home/ubuntu/environment/terraform-docker/noderedvol"
  }
}
```

## Testing and Verification

1. Deploy your Terraform configuration with `terraform apply`:

```bash
terraform apply --auto-approve
```

2. Test to ensure that Node-Red configurations are maintained through various deployment cycles. To access and test your Node-Red instance running on AWS Cloud9 via a browser using an IP address, follow these steps:

### Step 1: Find the Public IP Address of Your Cloud9 Instance

**Option 1**: Since Cloud9 environments are hosted on EC2 instances, you can find the public IP address of your instance as follows:

- Go to the **AWS Management Console**.
- Navigate to the **EC2 Dashboard**.
- Locate your Cloud9 instance in the list of EC2 instances.
- Find the **Public IP** address associated with your instance. It should be listed in the description or details pane of the instance.

**Option 2**: To find the public IP address of your AWS Cloud9 instance using the `curl` command, you can use the Amazon EC2 metadata service. This service provides information about running EC2 instances, and it's accessible from within the instance itself. Here's how you can do it:

- **Open the Cloud9 Terminal**: Access your Cloud9 environment and open the terminal.

- **Use the Curl Command**: In the terminal, enter the following command:

```bash
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

This command requests the public IPv4 address of your EC2 instance from the metadata service.

- **Note the IP Address**: The command should return an IP address, which is the public IP address of your Cloud9 instance.

### Step 2: Configure Security Group Rules

To access Node-Red on your Cloud9 instance from a web browser, you must ensure the security group attached to your EC2 instance allows inbound traffic on the port Node-Red is running on (usually port 1880).

- In the **EC2 Dashboard**, find the **Security Groups** section.
- Select the security group attached to your Cloud9 instance.
- Edit the **Inbound rules** to add a new rule:
  - **Type**: Custom TCP
  - **Port Range**: 1880
  - **Source**: Depending on your security preference, you can set this to `Anywhere` (0.0.0.0/0) or restrict it to your IP address for better security.

### Step 3: Access Node-Red in Your Browser

- Open a web browser and navigate to `http://[Your-Cloud9-Instance-Public-IP]:1880`.
- You should now see the Node-Red user interface.

### Step 4: Create a Simple Flow and Test

As described previously, create a simple flow using an `inject` node and a `debug` node, deploy it, and test it by injecting a timestamp.

### Step 5: Destroy the Current Terraform Setup

Run the `terraform destroy --auto-approve` command. This will remove all the resources managed by your Terraform configuration. Be aware that this includes your Node-Red instance and any other resources defined in your Terraform files.

```bash
terraform destroy --auto-approve
```

### Step 6: Reapply the Terraform Configuration

Once the destroy command has completed, run `terraform apply --auto-approve` to recreate the resources. This command will read your Terraform configuration files and recreate the infrastructure, including your Node-Red instance.

```bash
terraform apply --auto-approve
```

### Step 7: Verify Persistence

After the infrastructure is recreated:
- Access your Node-Red instance as you normally would (via the web interface using the instance’s IP address and the appropriate port, usually 1880).
- Check if your previous flows and configurations are still present and functioning as expected.

## Conclusion

Congratulations! You've learned to create a persistent Node-Red setup using Terraform, focusing on bind mounts and the Local Exec provisioner. This setup ensures data stability and consistency in your Node-Red deployments.

## References

- [Terraform Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container)
- [Node-Red Docker Documentation](https://nodered.org/docs/getting-started/docker)
- [Terraform Local Exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)
- [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)