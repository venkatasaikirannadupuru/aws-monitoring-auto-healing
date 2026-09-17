resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name        = "${var.project_name}-${var.environment}-high-cpu"
  alarm_description = "Alarm when EC2 CPU usage exceeds 80 percent for 5 minutes"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 80

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = {
    Name        = "${var.project_name}-high-cpu-alarm"
    Environment = var.environment
  }
}