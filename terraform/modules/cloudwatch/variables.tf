variable "instance_id" {
  type        = string
  description = "EC2 instance ID to monitor."
}

variable "alarm_sns_topic_arn" {
  type        = string
  description = "SNS topic ARN to publish alarm actions."
}

variable "cpu_threshold" {
  type        = number
  default     = 60
  description = "CPU threshold percentage that triggers the alarm."
}

variable "memory_threshold" {
  type        = number
  default     = 60
  description = "Memory utilization threshold percentage that triggers the alarm."
}

variable "disk_threshold" {
  type        = number
  default     = 60
  description = "Disk utilization threshold percentage that triggers the alarm."
}

