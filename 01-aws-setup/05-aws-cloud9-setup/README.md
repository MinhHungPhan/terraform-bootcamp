# AWS Cloud9 Setup

Welcome back! This document will guide you through setting up your AWS Cloud9 environment, an integrated coding platform designed to make it easy to write, run, and debug your scripts. Cloud9 provides a managed environment that eliminates the need for dealing with key management or additional security overhead, so you can focus on writing your Terraform code.

## Table of Contents

- [Introduction](#introduction)
- [Region Setup](#region-setup)
- [Cloud9 Instance Setup](#cloud9-instance-setup)
- [Cloud9 Preferences Configuration](#cloud9-preferences-configuration)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

After successfully securing our AWS account and setting up the necessary admin users, it's time to configure our environment to make it ready for development work. We'll be changing our region and setting up our AWS Cloud9 instance.

## Region Setup

First, change your region to North Virginia, if it's not already set to that.

## Cloud9 Instance Setup

Next, let's set up our Cloud9 instance. Here are the steps:
1. Enter `Cloud9` into the search bar.
2. Click on `Create Environment`.
3. Name the environment. In this tutorial, we'll use `Terraform` as the name.
4. Choose to create a new EC2 instance for the environment with direct access.
5. Select `t2.micro` to ensure it falls under the free tier.
6. Choose `Ubuntu Server 18.04 LTS`, which provides access to widely used packages.
7. Choose a cost-saving setting that suits your needs. For this tutorial, we'll select `After 30 minutes`.
8. Leave the network settings as default.
9. Proceed to the next step and click on `Create environment`.

## Cloud9 Preferences Configuration

Once the Cloud9 instance is set up, you can customize the interface according to your preference:
1. Change the editor theme. In this tutorial, we'll use `Cloud9 Light`.
2. Adjust the terminal display.
3. Alter your preferences for font size and other settings. 
4. Update the font size in the code editor settings for better readability.

With these settings, your Cloud9 environment should be well-prepared for the tasks ahead.

## Conclusion

You have now successfully set up your AWS Cloud9 environment and made it ready for use. Feel free to familiarize yourself with the interface, and adjust the settings to make the environment more comfortable for you to work in. Once you're ready, we can proceed to the next steps of the course.

## References

- [Getting started: basic tutorials for AWS Cloud9](https://docs.aws.amazon.com/cloud9/latest/user-guide/tutorials-basic.html)
- [Troubleshooting AWS Cloud9](https://docs.aws.amazon.com/cloud9/latest/user-guide/troubleshooting.html).