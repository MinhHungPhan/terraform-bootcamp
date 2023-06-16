# Securing Your AWS Account

This tutorial provides a guide on how to follow best practices for AWS account administration and how to enforce multi-factor authentication (MFA) on AWS IAM accounts.

## Table of Contents

- [Introduction](#introduction)
- [Enabling MFA for the Root User](#enabling-mfa-for-the-root-user)
- [Setting the Password Policy](#setting-the-password-policy)
- [Creating a User](#creating-a-user)
- [Logging Out of the Root Account](#logging-out-of-the-root-account)
- [Changing Sign-in Credentials](#changing-sign-in-credentials)
- [Logging In as the Administrative User](#logging-in-as-the-administrative-user)
- [Conclusion](#conclusion)

## Introduction

MFA (Multi-Factor Authentication) adds an extra layer of security by requiring multiple factors for authentication, such as a password and a unique code from a trusted device. It helps protect your accounts and data from unauthorized access.

According to AWS, it is recommended to use an IAM (Identity and Access Management) user for day-to-day AWS account administration. This provides an additional layer of security as it protects the root account in case of compromise.

## Enabling MFA for the Root User

Your root user controls everything from users to services, so it's crucial to secure it. Navigate to IAM or Identity and access management and activate MFA for your root user. If you can't use a cell phone, you may skip this step, but we strongly recommend following through. You can use applications like Google Authenticator to set up MFA.

## Setting the Password Policy

Next, establish your password policy. The recommended settings are:

- At least one upper case
- At least one lower case
- At least one number
- Password expiry every 90 days
- Password expiration requires an administrator reset
- Allow users to change their own passwords
- Prevent password reuse for at least the last five passwords

## Creating a User

Create a new user named after yourself and only provide AWS management console access. We will be working within `Cloud9` in the course, so programmatic access isn't necessary. If you're using a password manager, you can use that to generate a password.

## Logging Out of the Root Account

After creating a user, log out of your root account. If you want to add extra security, enable MFA for this new user as well.

## Changing Sign-in Credentials

Head back to the dashboard and change your sign-in credentials. Customize your alias according to your preferences. This will be the new link you use to sign in.

## Logging In as the Administrative User

Log back in as your administrative user using the new sign-in link and credentials you just set up.

## Relevant Documentation

- [Best practices for AWS account administration](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Creating IAM users and adding them to groups](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)

## Conclusion

By following the best practices for AWS account administration and enforcing multi-factor authentication, you can enhance the security of your AWS IAM accounts and protect your resources from unauthorized access.