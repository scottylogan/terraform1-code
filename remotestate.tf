# Create a KMS key for encrypting the Terraform state

resource "aws_kms_key" "remotestate" {
  description         = "KMS key for S3 remotestate"
  enable_key_rotation = true

  tags = {
    Name = "remotestate"
  }
}

# KMS keys have no naming, just randomly-generated ARNs.
# KMS aliases associate a human-readable name with a key.

resource "aws_kms_alias" "remotestate" {
  name          = "alias/remotestate"
  target_key_id = aws_kms_key.remotestate.id
}

# Create an S3 bucket using the name from the locals section in provider.tf
# We'll use a generic name for the Terraform resource so that it can be
# reference in other parts of the configuration as aws_s3_bucket.tfstate

resource "aws_s3_bucket" "tfstate" {
  bucket = local.tf_bucket
  acl    = "private"

  # enable server side encryption with the KMS key

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_alias.remotestate.target_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # enable automatic expiration of old versions of objects
  # this will delete old versions of the Terraform state
  # after 14 days. The latest version is unaffacted

  lifecycle_rule {
    id = "expiration"
    enabled = true
    expiration {
      expired_object_delete_marker = true
    }
    noncurrent_version_expiration {
      days = 14
    }

    # Also clean up any partially uploaded objects
    abort_incomplete_multipart_upload_days = 7
  }

  # enable versioning so that the state can be rolled back
  # in an emergency

  versioning {
    enabled = true
  }

}

