# Write Terraform configuration that creates CloudWatch Logs destination for kinesis, use awscc provider

# Create Kinesis Stream
resource "awscc_kinesis_stream" "this" {
  name                   = "terraform-kinesis-test"
  retention_period_hours = 48
  shard_count            = 1
  stream_mode_details = {
    stream_mode = "PROVISIONED"
  }
}

# Create IAM Policy Document with Trust Relationship for CloudWatch Logs
data "aws_iam_policy_document" "cloudwatch_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }
  }
}

# Create IAM Role with Kinesis Access
resource "awscc_iam_role" "main" {
  role_name                   = "sample_iam_role"
  description                 = "This is a sample IAM role"
  assume_role_policy_document = data.aws_iam_policy_document.cloudwatch_assume_role_policy.json
  managed_policy_arns         = ["arn:aws:iam::aws:policy/AmazonKinesisFullAccess"]
  path                        = "/"
}

# Create CloudWatch Log Destination
resource "awscc_logs_destination" "this" {
  destination_name = "test_destination"
  role_arn         = awscc_iam_role.main.arn
  target_arn       = awscc_kinesis_stream.this.arn
}
