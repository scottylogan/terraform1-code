# Terraform Tutorial Step 1

In this step we'll setup and initialize Terraform.

Ensure you're on the correct branch to start with:

```bash
% git checkout 1_setup
```

## Configure a Terraform Provider

We'll start by creating an AWS Terraform provider. Run

```bash
% ./setup profile-name region
```

replacing _profile-name_ with the name of the AWS profile you want to use, and _region_ with the AWS region to use.

If all goes well, you should have a `provider.tf` file that looks like this (with different profile and account_id values):

```bash
provider "aws" {
  region              = "us-west-2"
  profile             = "terraform-test"
  allowed_account_ids = [ "126147297478" ]
  version             = "~> 2.6"
}

terraform {
  required_version = ">= 0.12"
}

locals {
  profile    = "terraform-test"
  account_id = "126147297478"
  tf_bucket  = "126147297478-tfstate"
  tf_state   = "126147297478.tfstate"
}
```

# Initializing Terraform

Now you can initialize Terraform with

```bash
% terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.63.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Your directory should look like this:

```bash
% ls -AF
.git/        .gitignore   .terraform/  README.md    provider.tf  setup.sh*
```

# Terraform State

Terraform tracks all the resources it manages. By default this is a file called `terraform.tfstate` in the current directory. While you can manage the state file with `git` (along with a tool like `git-crypt` to encrypt the state file to protect any sensitive data), it's cumbersome if you're working with a team: everyone has to remember to `git push` frequently, and to always `git pull` before making any changes.

You can also store the state in an AWS S3 bucket, where it can be versioned and encrypted automatically. Before we can configure Terraform to use a bucket for remote state, the bucket must be created... so let's create it with Terraform.

# Creating an S3 Bucket

An S3 bucket can be a very simple Terraform resource:

```
resource "aws_s3_bucket" "tfstate" {
  bucket = "my-bucket"
}
```

However, for our Terraform state bucket, we want to keep it private, keep older versions of the state, and encrypt the state to protect secrets, passwords, etc.

S3 can encrypt buckets using a default key per AWS account, but it's better to create a separate key for the Terraform bucket.

Look at `remotestate.tf`. We start by creating a KMS key, then create a human-friendly alias for the key. Finally, we create the S3 bucket, with private access, expiration of old versions after 14 days, and encryption with the KMS key.

# Planning Changes

To see what Terraform will create, run `terraform plan`:

```bash
% terraform plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_kms_alias.remotestate will be created
  + resource "aws_kms_alias" "remotestate" {
      ...
    }

  # aws_kms_key.remotestate will be created
  + resource "aws_kms_key" "remotestate" {
      ...
    }

  # aws_s3_bucket.tfstate will be created
  + resource "aws_s3_bucket" "tfstate" {
      ...
    }

Plan: 3 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

Assuming everything looks OK, you can create the resources.

# Creating Resources with Terraform

Run `terraform apply` to create the resources. Terraform will output the plan again:

```bash
% terraform apply
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_kms_alias.remotestate will be created
  + resource "aws_kms_alias" "remotestate" {
      ...
    }

  # aws_kms_key.remotestate will be created
  + resource "aws_kms_key" "remotestate" {
      ...
    }

  # aws_s3_bucket.tfstate will be created
  + resource "aws_s3_bucket" "tfstate" {
      ...
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```


Terraform will ask for confirmation before proceeding. Enter `yes` when prompted:

```bash
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: `yes`
aws_kms_key.remotestate: Creating...
aws_kms_key.remotestate: Creation complete after 6s [id=f93fdba9-c529-41c3-8a0c-167d7f8b3ce7]
aws_kms_alias.remotestate: Creating...
aws_kms_alias.remotestate: Creation complete after 1s [id=alias/remotestate]
aws_s3_bucket.tfstate: Creating...
aws_s3_bucket.tfstate: Creation complete after 4s [id=126147297478-tfstate]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

Your directory should look like this:

```bash
% ls -AF
.git/              .terraform/        provider.tf        setup.sh*
.gitignore         README.md          remotestate.tf     terraform.tfstate
```

Your state is still being stored in `terraform.tfstate`... checkout the next step to migrate it to S3:

```bash
% git checkout 2_remotestate
```
