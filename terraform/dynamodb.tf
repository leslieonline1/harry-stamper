resource "aws_dynamodb_global_table" "harryStamper" {
  depends_on = ["aws_dynamodb_table.harryStamper-eu-west-1", "aws_dynamodb_table.harryStamper-eu-central-1"]
  provider   = "aws.eu-west-1"

  name = "harryStamper"

  replica {
    region_name = "eu-west-1"
  }

  replica {
    region_name = "eu-central-1"
  }
}