# Terraform Dependency Lock

Welcome to this guide where we'll discuss how to effectively manage versioning in Terraform. One of the commonly faced challenges in software development is managing versions and Terraform is no exception. This guide is designed to help beginners navigate this challenge and ensure their code runs consistently across different environments. 

## Table of Contents

- [Introduction](#introduction)
- [Versioning in Terraform](#versioning-in-terraform)
- [The terraform.lock.hcl File](#the-terraformlockhcl-file)
- [Version Constraints](#version-constraints)
- [Understanding the Pessimistic Constraint Operator](#understanding-the-pessimistic-constraint-operator)
- [Conclusion](#conclusion)
- [References](#references)

## Introduction

One of the major aspects of software development that can be a bit aggravating is versioning. This is particularly relevant for those who have been using Terraform over the past few years, as you may have encountered some of the big breaking changes that HashiCorp has released.

## Versioning in Terraform

HashiCorp has addressed these versioning challenges by introducing a mechanism similar to JavaScript's package.json file, allowing developers to constrain versions. This mechanism ensures that everyone who downloads your code from source control systems such as GitLab or GitHub is constrained to the same provider versions.

## The .terraform.lock.hcl File

This file allows you to ensure that the version remains consistent across different setups. While it doesn't constrain the Terraform version (since it's a binary on your terminal), it does ensure that the provider version remains the same. It's worth noting that any changes made manually to this file may be lost during future updates as it is maintained automatically by `terraform init`.

### Purpose of `.terraform.lock.hcl`

1. **Dependency Locking**: The `.terraform.lock.hcl` file is used by Terraform to lock the versions of the providers used in a Terraform project. This helps ensure that the same versions are used every time Terraform is run, across different environments and different team members. This consistency is critical for avoiding subtle bugs or changes caused by differing provider versions.

2. **Cross-platform Compatibility**: This lock file contains information about each provider's version and its checksums for different system architectures. This helps in ensuring that the providers will work correctly no matter the operating system or architecture on which Terraform is executed.

3. **Version Control Integration**: The file is intended to be checked into version control systems along with the rest of the Terraform configuration. This shared versioning ensures that all team members and deployment pipelines use precisely the same set of provider versions.

### Contents of `.terraform.lock.hcl`

- **Provider Versions**: It lists the specific versions of the providers that are currently being used in the project.
- **Checksums**: For each provider, there are checksums corresponding to various platforms, ensuring that the correct and unaltered version of the provider is used during deployments.
- **Provider Source Information**: Details about where each provider can be downloaded from, usually the Terraform Registry or a direct URL.

### How It Works

- When you initialize a Terraform configuration using `terraform init`, Terraform scans the configuration for required providers and their constraints. It then updates the `.terraform.lock.hcl` file with the appropriate provider versions and checksums that match the specified constraints and the platform being used.
- If a suitable version is already recorded in the lock file and it matches the constraints, Terraform uses this version without further internet queries. This speeds up the initialization process and reduces the likelihood of unexpected changes if a provider releases a new version.
- To update a provider to a newer version that still fits within the specified constraints, you can use the `terraform init -upgrade` command. This command will update the lock file with the new version's details.

## Version Constraints

Terraform allows you to specify constraints for the required providers in your Terraform configuration. These constraints guide Terraform to use a specific version of a provider or to stay within a range of versions. This can be particularly useful when you need to ensure compatibility with certain versions of a provider.

## Understanding the Pessimistic Constraint Operator

In Terraform, the '~>' operator, also known as the pessimistic constraint operator, ensures that the rightmost number of the version increases as much as possible without incrementing the number to the left of that. This ensures that you can receive minor updates and bug fixes without risking the introduction of breaking changes that might come with a major version update.

## Hands-on

This section provides an example of a `.terraform.lock.hcl` file and `main.tf` file, as well as some commands you might use when working with Terraform.

**.terraform.lock.hcl**:

```hcl
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/kreuzwerker/docker" {
 version = "3.0.2"
...
}
```

### Make the first change

**main.tf**:

```hcl
terraform {
 required_providers {
   docker = {
     source = "kreuzwerker/docker"
     version = "~ 2.12.0"
   }
 }
}

provider "docker" {}
```

Now let's initialize the provider plugins with `terraform init`:

```bash
terraform init
```

Expected output:

```plaintext
Initializing provider plugins...
- Reusing previous version of kreuzwerker/docker from the dependency lock file
╷
│ Error: Failed to query available provider packages
│
│ Could not retrieve the list of available versions for provider kreuzwerker/docker: locked
│ provider registry.terraform.io/kreuzwerker/docker 3.0.2 does not match configured version
│ constraint 2.12.0; must use terraform init -upgrade to allow selection of new versions
```

To resolve the error, we can upgrade the provider plugins with `terraform init -upgrade`:

```bash
terraform init -upgrade
```

Expected output:

```plaintext
Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "2.12.0"...
- Installing kreuzwerker/docker v2.12.0...
- Installed kreuzwerker/docker v2.12.0 (self-signed, key ID 24E54F214569A8A5)


Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html


Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.


Terraform has been successfully initialized!
...
```

Now if we check the `.terraform.lock.hcl` file again, we can see the changes:

```plaintext
provider "registry.terraform.io/kreuzwerker/docker" {
 version     = "2.12.0"
 constraints = "2.12.0"
 ...
}
```

### Make the second change

**main.tf**:

```hcl
terraform {
 required_providers {
   docker = {
     source = "kreuzwerker/docker"
     version = "~> 2.15.0"
   }
 }
}

provider "docker" {}
```

Run the following command to initialize Terraform and upgrade provider plugins again:

```bash
terraform init -upgrade
```

Expected output:

```plaintext
Initializing the backend...


Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 2.15.0"...
- Installing kreuzwerker/docker v2.15.0...
- Installed kreuzwerker/docker v2.15.0 (self-signed, key ID BD080C4571C6104C)
...
```

## Best Practices

- **Commit the Lock File**: Always commit the `.terraform.lock.hcl` file to your version control system to ensure that every member of your team and your deployment systems use the exact same provider versions.
- **Review Changes**: When updating providers, review changes to the `.terraform.lock.hcl` file to understand which versions are being updated and ensure these changes are intentional and well-understood.

## Conclusion

Managing versions in Terraform is crucial to ensure that your code behaves as expected, irrespective of the environment in which it is run. This guide has walked you through the essential aspects of managing versions in Terraform and how to set version constraints. By following these best practices, you can write Terraform configurations that are consistent and reliable.

## References

- [Terraform Official Documentation](https://www.terraform.io/docs/language/index.html)
- [Terraform Version Constraints](https://www.terraform.io/docs/language/expressions/version-constraints.html)
- [Dependency Lock File](https://developer.hashicorp.com/terraform/language/files/dependency-lock)
- [Terraform Tutorials](https://developer.hashicorp.com/terraform/tutorials)
