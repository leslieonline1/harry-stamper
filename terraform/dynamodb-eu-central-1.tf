resource "aws_dynamodb_table" "harryStamper-eu-central-1" {
  provider = "aws.eu-central-1"

  hash_key         = "Region"
  range_key        = "Timestamp"
  name             = "harryStamper"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = "Region"
    type = "S"
  }

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

resource "aws_appautoscaling_target" "dynamodb_table_write_target-eu-central-1" {
  provider = "aws.eu-central-1"
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/harryStamper"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy-eu-central-1" {
  provider = "aws.eu-central-1"
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target-eu-central-1.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_write_target-eu-central-1.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_write_target-eu-central-1.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_write_target-eu-central-1.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}