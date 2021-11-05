resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "tennis-dashboard"
  dashboard_body = <<EOF
{
  "widgets": [
    {
        "type": "log",
        "x": 0,
        "y": 0,
        "properties": {
        "query": "SOURCE '/aws/lambda/${aws_lambda_function.function.function_name}' | fields @timestamp, @message\n| filter @message like 'Moved'\n| sort @timestamp desc\n| display @timestamp, @message",
        "region": "us-east-1",
        "title": "AWSTennis",
        "view": "table"
        }
    }
  ]
}
EOF
}
