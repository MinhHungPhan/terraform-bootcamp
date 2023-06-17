# Configuring Security Group

## Table of Contents

- [Introduction](#introduction)
- [Accessing Your Cloud9 Instance](#accessing-your-cloud9-instance)
- [Security Group Configuration](#security-group-configuration)
- [Obtaining Your IP Address](#obtaining-your-ip-address)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

Welcome back! In this guide, we will continue where we left off with our Cloud9 setup. It's crucial that our local machine has the necessary access to interact with our Cloud9 instance. This includes viewing any running containers, websites, or applications that are hosted on it. We will also cover how to navigate to the AWS console, locate the instance, and adjust security settings accordingly.

## Accessing Your Cloud9 Instance

To access your Cloud9 instance, follow these steps:

1. At the top of the AWS Management Console, you'll find a search bar. Click on it or use the keyboard shortcut "/" to activate the search function.

2. Type "Cloud9" in the search bar and press Enter or click on the magnifying glass icon to initiate the search.

**Note**: If the search results don't appear immediately, wait for a moment as it may take some time to populate.

3. Once the search results are displayed, look for and click on the "Cloud9" service among the listed options. This action will take you to the Cloud9 console.

4. In the Cloud9 console, locate and click on the "Environments" tab on the left-hand side menu. This tab contains the list of your Cloud9 environments.

5. Look for your Cloud9 instance in the list of environments. It should be tagged as "aws-cloud9-kientree-abcxyz123456" or similar. You can verify that you're looking at the correct instance by checking its name and any additional tags or identifiers.

Now you have successfully accessed the AWS console and found your specific Cloud9 instance. You can proceed with any further actions or modifications you need to perform on your Cloud9 environment.

## Security Group Configuration

To configure the security group for your Cloud9 instance, perform the following steps:

1. After locating and verifying your Cloud9 instance in the AWS console, click on it to access its details and configuration.

2. Scroll down the instance details page until you reach the "Security" section. Here, you will find the associated security groups for your Cloud9 instance.

3. Click on the security group associated with your Cloud9 instance. This action will take you to the configuration page for that security group.

4. On the security group configuration page, locate the "Inbound Rules" or "Inbound" section. This is where you can define the rules for incoming traffic.

5. Click on the "Edit" or "Add Rule" button in the "Inbound Rules" section to add a new rule.

6. In the rule configuration dialog, choose the option to add a new rule and select the appropriate rule type (e.g., TCP, UDP, All Traffic).

7. Specify the source for the inbound traffic. To permit all traffic from your local machine, choose the option to specify an IP address or IP range. Enter the IP address or IP range that corresponds to your local machine's network.

**Note**: If you're unsure about the IP address or range to enter, you can usually find it by searching for "What is my IP address" on a search engine using your local machine.

8. Optionally, you can limit the ports for the inbound rule if needed. However, if you're using varying port ranges, it's suggested to leave the ports unrestricted to grant all access.

9. After configuring the rule, click on the "Save" or "Add Rule" button to apply the changes.

## Obtaining Your IP Address

In order to add the new inbound rule, you need your computer's public IP address.

To obtain your IP address, follow the steps below:

1. Obtain your computer's public IP address by searching "What's my IP?" on Google or using a website like IP Chicken.

2. Go to the AWS Management Console and navigate to the security group configuration for your Cloud9 instance.

3. Add a new inbound rule and paste your IP address in the "Source" field. The "/32" suffix indicates only that specific IP address is allowed.

4. Provide a description for the rule, such as "Access from personal computer."

5. Save the rule and make sure to update it if your IP address changes in the future.

**Note:** Regularly review and update the rule as needed to maintain access to your applications.

## Relevant Documentation

- [AWS Cloud9 Documentation](https://docs.aws.amazon.com/cloud9/latest/user-guide/welcome.html)
- [AWS Security Groups for Your VPC](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

## Conclusion

In this guide, we've established how to grant secure access to your Cloud9 instance from your local machine. Remember to check your security settings if your IP address changes or if you encounter issues with your applications. This guide is a stepping stone in your AWS Cloud9 journey. Thank you for following along, and stay tuned for the upcoming sections of this course. Happy coding!
