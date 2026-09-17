data "archive_file" "remediation" {
  type        = "zip"
  source_file = "../lambda/remediation.py"
  output_path = "${path.module}/remediation.zip"
}

resource "aws_lambda_function" "remediation" {
  function_name = "${var.project_name}-${var.environment}-remediation"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.12"
  handler = "remediation.lambda_handler"

  filename         = data.archive_file.remediation.output_path
  source_code_hash = data.archive_file.remediation.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_policy
  ]

  tags = {
    Name        = "${var.project_name}-remediation"
    Environment = var.environment
  }
}
