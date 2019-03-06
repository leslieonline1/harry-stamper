resource "aws_api_gateway_rest_api" "harryStamper-eu-central-1" {
  provider = "aws.eu-central-1"
  
  name        = "harryStamper"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  description = "The Harry Stamper timestamp application"
}