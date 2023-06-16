# Expanding the AWS Cloud9 Instance Volume

Hello and welcome back! Throughout this course, you will be dealing with a significant amount of data, including downloading Docker images and installing various files and applications. Due to this heavy filesystem usage, you may run out of storage space on your Cloud9 instance. This guide will demonstrate how you can expand your Cloud9 volume to avoid such issues.

## Table of Contents

- [Introduction](#introduction)
- [Disk Space Issue](#disk-space-issue)
- [Cleaning Up](#cleaning-up)
- [Expanding the Volume](#expanding-the-volume)
- [Verifying the Changes](#verifying-the-changes)
- [Relevant Documentation](#relevant-documentation)
- [Conclusion](#conclusion)

## Introduction

As you progress through the course, heavy filesystem usage might result in running out of storage space on your Cloud9 instance. AWS Cloud9 instances come with a default volume size of 10 GB, which might be insufficient for downloading all the Docker images and other resources required for this course.

## Disk Space Issue

Running the `df` command can confirm whether you're running out of space. If you encounter an error indicating `No space left on device`, it's a sign that your instance is running out of storage.

## Cleaning Up

While you can perform cleanup actions to free up some space temporarily, like running the `docker system prune -a` command to remove all Docker images and build caches, this solution might not be enough as you advance in the course.

```bash
docker system prune -a
```

Expected output:

```plaintext
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all images without at least one container associated to them
  - all build cache

Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
```

**Note**: It's also important to note that you should only run this command in a dev machine for this course and not in a production environment.

## Expanding the Volume

The most effective solution to this issue is to increase the volume size of your Cloud9 instance. Remember, the AWS free tier allows up to 30 GB of EBS volume space, and you can utilize this space to expand your Cloud9 instance. 

To do this, we'll create a script by following these steps:

1. Create a new bash script file:

```bash
vi resize.sh
```

**Note**: You can find the content of the resize.sh file in the scripts directory at the [following link](scripts/resize.sh)

2. Make the script executable by running the command:

```bash
chmod +x resize.sh
```

3. pen the file and paste the provided script into it. You can then run the script with the desired size, like so:

```bash
./resize.sh 30
```

This command will resize the volume to 30 GB.

**Please note** that the AWS free tier's EBS space is pooled, so if you have other EC2 instances, their volume sizes will also count against the 30 GB limit.

## Verifying the Changes

After the resize process finishes, you can verify the changes using the `df` command. This will show you the new size, used space, and available space.

## Relevent Documentation

- [AWS Cloud9 Documentation](https://docs.aws.amazon.com/cloud9/latest/user-guide/welcome.html)
- [Docker System Prune](https://docs.docker.com/engine/reference/commandline/system_prune/)

## Conclusion

Congratulations! You have now successfully expanded the volume size of your AWS Cloud9 instance, providing you with ample space to download images, install applications, and carry out other tasks throughout this course.