resource "aws_sns_topic" "ivolve-sns" {
  name = "alarm-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.ivolve-sns.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}

