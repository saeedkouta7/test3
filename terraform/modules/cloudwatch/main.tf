resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "high-cpu-utilization-${var.instance_id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "Alarm when CPU exceeds ${var.cpu_threshold}%"
  alarm_actions       = [var.alarm_sns_topic_arn]
  dimensions = {
    InstanceId = var.instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "high_memory_utilization" {
  alarm_name          = "high-memory-utilization-${var.instance_id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = var.memory_threshold
  alarm_description   = "Alarm when Memory exceeds ${var.memory_threshold}%"
  alarm_actions       = [var.alarm_sns_topic_arn]
  dimensions = {
    InstanceId = var.instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "high_disk_utilization" {
  alarm_name          = "high-disk-utilization-${var.instance_id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = var.disk_threshold
  alarm_description   = "Alarm when Disk exceeds ${var.disk_threshold}%"
  alarm_actions       = [var.alarm_sns_topic_arn]
  dimensions = {
    InstanceId = var.instance_id
  }
}

