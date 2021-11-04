resource "aws_iam_role" "role" {
  name                = "pp-role-${local.region}-${local.account_id}"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  inline_policy {
    name = "pp-policy-${local.region}-${local.account_id}"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:*"]
          Effect   = "Allow"
          Resource = [
            "${aws_s3_bucket.bucket1.arn}",
            "${aws_s3_bucket.bucket1.arn}/*",
            "${aws_s3_bucket.bucket2.arn}",
            "${aws_s3_bucket.bucket2.arn}/*",
          ]
        },
      ]
    })
  }
}

resource "aws_lambda_function" "function" {
  architectures    = ["arm64"]
  filename         = "./modules/tennis/resources/lambda_function.zip"
  function_name    = "pp-lambda-${local.region}-${local.account_id}"
  role             = aws_iam_role.role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("./modules/tennis/resources/lambda_function.zip")
  runtime          = "python3.9"
  timeout          = 10
  environment {
    variables = {
      ENABLED = "true",
      BUCKET1 = aws_s3_bucket.bucket1.bucket,
      BUCKET2 = aws_s3_bucket.bucket2.bucket
    }
  }
}
