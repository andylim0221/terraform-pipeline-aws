resource "aws_s3_bucket" "bucket_trail" {
  bucket        = "pp-buckettrail-${local.region}-${local.account_id}"
  acl           = "private"
  force_destroy = true

  policy        = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.bucket_trail.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.bucket_trail.arn}/*"
        }
    ]
}
POLICY

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
