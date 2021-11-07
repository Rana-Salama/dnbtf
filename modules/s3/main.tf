#This module creates the S3 bucket resources
resource "aws_s3_bucket" "user" {
  bucket = "${var.role}-${var.project}"
}
resource "aws_s3_bucket" "keystore" {
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.keystore.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Can be enhanced to handle adding the keys as a list rather than a string https://newbedev.com/uploading-multiple-files-in-aws-s3-from-terraform

resource "aws_s3_bucket_object" "keys" {
  bucket                 = aws_s3_bucket.keystore.id
  key                    = "${var.role}-user.pub"
  source                 = var.public_key_location
  server_side_encryption = "aws:kms"
}

