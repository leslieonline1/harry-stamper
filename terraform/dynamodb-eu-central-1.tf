resource "aws_dynamodb_table" "harryStamper-eu-central-1" {
  provider = "aws.eu-central-1"

  hash_key         = "Timestamp"
  name             = "harryStamper"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = "Timestamp"
    type = "S"
  }

  lifecycle {
    ignore_changes = [
      "read_capacity",
      "write_capacity",
    ]
  }
}