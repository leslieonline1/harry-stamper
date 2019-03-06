resource "aws_lambda_function" "harryStamper-eu-north-1" {
    provider = "aws.eu-north-1"

  function_name = "harryStamper"

  s3_bucket = "harry-stamper"
  s3_key    = "harryStamper.zip"

  handler = "main"
  runtime = "go1.x"

  role = "${aws_iam_role.lambda_exec-eu-north-1.arn}"
}

resource "aws_iam_role" "lambda_exec-eu-north-1" {
  provider = "aws.eu-north-1"

  name = "harryStamper_lambda"

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

resource "aws_api_gateway_resource" "proxy-eu-north-1" {
    provider = "aws.eu-north-1"

  rest_api_id = "${aws_api_gateway_rest_api.harryStamper-eu-north-1.id}"
  parent_id   = "${aws_api_gateway_rest_api.harryStamper-eu-north-1.root_resource_id}"
  path_part   = "/app"
}

resource "aws_api_gateway_method" "proxy-eu-north-1" {
    provider = "aws.eu-north-1"

  rest_api_id   = "${aws_api_gateway_rest_api.harryStamper-eu-north-1.id}"
  resource_id   = "${aws_api_gateway_resource.proxy-eu-north-1.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda-eu-north-1" {
    provider = "aws.eu-north-1"

  rest_api_id = "${aws_api_gateway_rest_api.harryStamper-eu-north-1.id}"
  resource_id = "${aws_api_gateway_method.proxy-eu-north-1.resource_id}"
  http_method = "${aws_api_gateway_method.proxy-eu-north-1.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.harryStamper-eu-north-1.invoke_arn}"
}

resource "aws_api_gateway_deployment" "harryStamper-eu-north-1" {
    provider = "aws.eu-north-1"

  depends_on = [
    "aws_api_gateway_integration.lambda-eu-north-1"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.harryStamper-eu-north-1.id}"
  stage_name  = "production"
}

resource "aws_lambda_permission" "apigw-eu-north-1" {
    provider = "aws.eu-north-1"
    
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.harryStamper-eu-north-1.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_deployment.harryStamper-eu-north-1.execution_arn}/*/*"
}

output "eu-north-1-base_url" {
  value = "${aws_api_gateway_deployment.harryStamper-eu-north-1.invoke_url}"
}