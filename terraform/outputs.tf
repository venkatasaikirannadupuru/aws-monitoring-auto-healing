output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "ec2_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.app.public_ip
}

output "application_url" {
  description = "Application URL"
  value       = "http://${aws_instance.app.public_ip}"
}

output "lambda_function_name" {
  description = "Auto-healing Lambda function"
  value       = aws_lambda_function.remediation.function_name
}

output "sns_topic_arn" {
  description = "SNS alert topic ARN"
  value       = aws_sns_topic.alerts.arn
}

output "cloudwatch_alarm_name" {
  description = "High CPU CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "eventbridge_rule_name" {
  description = "EC2 state-change EventBridge rule"
  value       = aws_cloudwatch_event_rule.ec2_state_change.name
}
