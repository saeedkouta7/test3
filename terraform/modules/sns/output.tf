output "sns_topic_arn" {
  value = aws_sns_topic.ivolve-sns.arn
  description = "ARN of the SNS topic used for notifications."
}

