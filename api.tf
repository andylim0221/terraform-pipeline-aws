resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
}

resource "aws_api_gateway_model" "model" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "UserModel"
  description  = "Request schema model."
  content_type = "application/json"
  schema       = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "UserModel",
  "type": "object",
  "required": ["myname"],
  "properties": {
    "myname": {
      "type": "string"
    }
  },
  "additionalProperties": false
}
EOF
}

resource "aws_api_gateway_request_validator" "validator" {
  name                        = "validator"
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "event"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.resource.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
  request_models = {
    "application/json" = aws_api_gateway_model.model.name
  }
  request_parameters = {
    "method.request.header.x-api-key"    = true
    "method.request.header.content-type" = true
    "method.request.querystring.code"    = true
  }
  request_validator_id = aws_api_gateway_request_validator.validator.id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.tf_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
}

# resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
#   rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
#   resource_id = aws_api_gateway_resource.MyDemoResource.id
#   http_method = aws_api_gateway_method.MyDemoMethod.http_method
#   status_code = aws_api_gateway_method_response.response_200.status_code

#   # Transforms the backend JSON response to XML
#   response_templates = {
#     "application/xml" = <<EOF
# #set($inputRoot = $input.path('$'))
# <?xml version="1.0" encoding="UTF-8"?>
# <message>
#     $inputRoot.body
# </message>
# EOF
#   }
# }

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "test"
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = false
    logging_level          = "OFF"
    throttling_rate_limit  = 1000
    throttling_burst_limit = 500
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "my_api_key"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name        = "my_usage_plan"
  description = "API usage plan."

  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_stage.stage.stage_name
  }

  quota_settings {
    limit  = 10000
    offset = 0
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 500
    rate_limit  = 1000
  }
}

resource "aws_api_gateway_usage_plan_key" "plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  resource_arn = aws_api_gateway_stage.stage.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_regional.arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/${aws_api_gateway_method.method.http_method}/${aws_api_gateway_resource.resource.path_part}"
}

output "API_Endpoint" {
  value     = "${aws_api_gateway_stage.stage.invoke_url}/${aws_api_gateway_resource.resource.path_part}"
  sensitive = false
}
