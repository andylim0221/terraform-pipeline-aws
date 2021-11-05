resource "aws_s3_bucket" "bucket_trail" {
  bucket        = "pp-buckettrail-${local.region}-${local.account_id}"
  acl           = "private"
  force_destroy = true
  policy        = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::pp-buckettrail-${local.region}-${local.account_id}",
        "arn:aws:s3:::pp-buckettrail-${local.region}-${local.account_id}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "bucket_trail" {
  bucket                  = aws_s3_bucket.bucket_trail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudtrail" "trail" {
  name                          = "pp-cloudtrail-${local.region}-${local.account_id}"
  s3_bucket_name                = aws_s3_bucket.bucket_trail.bucket
  include_global_service_events = false
  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false
    data_resource {
      type = "AWS::S3::Object"
      # Make sure to append a trailing '/' to your ARN if you want
      # to monitor all objects in a bucket.
      values = [
        "${aws_s3_bucket.bucket1.arn}/",
        "${aws_s3_bucket.bucket2.arn}/"
      ]
    }
  }
}
