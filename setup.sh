#! /bin/bash

export AWS_PAGER="" AWS_DEFAULT_OUTPUT=json

if ! type -P jq >/dev/null; then
  echo "Error: did not find jq. Please install jq and try again" >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: ./$(basename $0) profile [region]" >&2
  exit 1
fi

profile=$1
if ! aws configure list-profiles 2>/dev/null | grep -q "^${profile}$" ; then
  echo "Error: ${profile} does not appear to be defined" >&2
  exit 1
fi

region=${2:-$(aws configure get region)}
account_id=$(aws iam get-user --profile ${profile} | jq -r '.User.Arn|split(":")[4]')
tf_bucket=${account_id}-tfstate
tf_state=${tf_bucket/-/.}

cat >provider.tf <<PROVIDER
provider "aws" {
  region              = "${region}"
  profile             = "${profile}"
  allowed_account_ids = [ "${account_id}" ]
  version             = "~> 2.6"
}

terraform {
  required_version = ">= 0.12"
}

locals {
  profile    = "${profile}"
  account_id = "${account_id}"
  tf_bucket  = "${tf_bucket}"
  tf_state   = "${tf_state}"
}

# Remote State
terraform {
  backend "s3" {
    bucket = "${tf_bucket}"
    key    = "${tf_state}"
    region = "${region}"
    profile = "${profile}"
  }
}
PROVIDER
