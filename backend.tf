#Create s3 bucket
resource "aws_s3_bucket" "env_backend" {
  count = var.create_bucket ? 1 : 0

  bucket = "bootcamp29-${random_integer.bucket_name.result}-${var.name}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

#Backet ACL
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.env_backend[0].id
  acl    = var.acl
}

#Bucket Versonning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.env_backend[0].id
  versioning_configuration {
    status = var.versioning
  }
}

#KMS ID
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

#Server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "ss_kms" {
  bucket = aws_s3_bucket.env_backend[0].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#Random Integer
resource "random_integer" "bucket_name" {
  min = 1
  max = 100
  keepers = {
    # Generate a new integer each time we switch to a new listener ARN
    bucket_name = var.name
  }
}
