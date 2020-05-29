# Terraform Tutorial Step 2

In this step we'll migrate the Terraform state to the S3 bucket.

Ensure you're on the correct branch to start with:

```bash
% git checkout 2_remotestate
```

## Re-configure the Terraform Provider

We'll start by reconfiguring the AWS Terraform provider. Run

```bash
% ./setup profile-name region
```

using the same _profile-name_ and _region_ as before.

If all goes well, you should have a `provider.tf` file that now has a remote state configuration that looks like:

```
# Remote State
terraform {
  backend "s3" {
    bucket = "126147297478-tfstate"
    key    = "126147297478.tfstate"
    region = "us-west-2"
    profile = "terraform-test"
  }
}
```

Unfortunately, as of Terraform v0.12.24, variables and locals cannot be used to configure providers or backends.


# Re-initializing Terraform

Terraform needs to be-initialized to migrate to the remote state. You'll be prompted for confirmation that you want to move the state to S3; answer with `yes`.

```bash
% terraform init
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "s3" backend. No existing state was found in the newly
  configured "s3" backend. Do you want to copy this state to the new "s3"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: 

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...

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
% ls -F
README.md                 remotestate.tf            terraform.tfstate
provider.tf               setup.sh*                 terraform.tfstate.backup
```

You can now delete the local state file and state backup file:

```bash
% rm terraform.tfstate terraform.tfstate.backup
% ls -F
README.md       provider.tf     remotestate.tf  setup.sh*
```

Now, check your remote state:

```bash
% terraform state list
aws_kms_alias.remotestate
aws_kms_key.remotestate
aws_s3_bucket.tfstate
```

