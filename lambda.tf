resource "aws_iam_role" "iam_for_lambda" {
  name               = format("%s_role", var.lambda_name)
  assume_role_policy = <<EOF
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
}

resource "aws_lambda_function" "tf_lambda" {
  architectures    = ["arm64"]
  filename         = "resources/lambda_function.zip"
  function_name    = var.lambda_name
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("resources/lambda_function.zip")
  runtime          = "python3.9"
  environment {
    variables = {
      ENCODING = "latin-1"
      CORS     = "*"
    }
  }
}
