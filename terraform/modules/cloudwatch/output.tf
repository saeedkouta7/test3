output "cpu_alarm_id" {
  value = aws_cloudwatch_metric_alarm.high_cpu_utilization.id
}

output "memory_alarm_id" {
  value = aws_cloudwatch_metric_alarm.high_memory_utilization.id
}

output "disk_alarm_id" {
  value = aws_cloudwatch_metric_alarm.high_disk_utilization.id
}

