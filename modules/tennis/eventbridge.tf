resource "aws_cloudwatch_event_rule" "rule" {
  name          = "pp-rule-${local.region}-${local.account_id}"
  event_pattern = <<EOF
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject"
    ],
    "requestParameters": {
      "bucketName": [
        "${aws_s3_bucket.bucket1.bucket}",
        "${aws_s3_bucket.bucket2.bucket}"
      ]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "pp-lambda-${local.region}-${local.account_id}"
  arn       = aws_lambda_function.function.arn
  input_transformer {
    input_paths = {
      bucket = "$.detail.requestParameters.bucketName"
      key    = "$.detail.requestParameters.key"
    }
    input_template = <<EOF
{"bucket": <bucket>, "key": <key>}
EOF
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule.arn
}
