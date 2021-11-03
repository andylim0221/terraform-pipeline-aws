resource "aws_s3_bucket" "bucket1" {
  bucket = "pp-bucket1-${local.region}-${local.account_id}"
  acl    = "private"
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "pp-bucket2-${local.region}-${local.account_id}"
  acl    = "private"
}

