resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name        = "${var.project_name}-${var.environment}-ec2-state-change"
  description = "Detect state changes for the auto-healing EC2 instance"

  event_pattern = jsonencode({
    source = [
      "aws.ec2"
    ]

    "detail-type" = [
      "EC2 Instance State-change Notification"
    ]

    detail = {
      state = [
        "stopped",
        "terminated"
      ]

      "instance-id" = [
        aws_instance.app.id
      ]
    }
  })

  tags = {
    Name        = "${var.project_name}-ec2-state-change"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.ec2_state_change.name
  arn  = aws_lambda_function.remediation.arn
}

resource "aws_lambda_permission" "eventbridge" {
  statement_id = "AllowEventBridgeInvoke"

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.remediation.function_name
  principal     = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.ec2_state_change.arn
}