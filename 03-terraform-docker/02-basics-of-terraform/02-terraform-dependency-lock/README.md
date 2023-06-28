# Terraform Version Management

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

## Conclusion

Managing versions in Terraform is crucial to ensure that your code behaves as expected, irrespective of the environment in which it is run. This guide has walked you through the essential aspects of managing versions in Terraform and how to set version constraints. By following these best practices, you can write Terraform configurations that are consistent and reliable.

## References

- [Terraform Official Documentation](https://www.terraform.io/docs/language/index.html)
- [Terraform Version Constraints](https://www.terraform.io/docs/language/expressions/version-constraints.html)
- [Terraform Tutorials](https://developer.hashicorp.com/terraform/tutorials)
