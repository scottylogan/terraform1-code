# Terraform Tutorial


## Branch: 1_setup

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

```
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
