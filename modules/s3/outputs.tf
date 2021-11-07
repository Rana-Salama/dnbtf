

output "keystore_bucket" {
  value = aws_s3_bucket.keystore.bucket
}

output "team_project_bucket" {
  value = aws_s3_bucket.user.bucket
}
