variable "ami" {
  description = "The AMI ID for the instance"
  default     = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  description = "The instance type"
  default     = "t2.large"
}

variable "key_name" {
  description = "The key pair name"
  default     = "ivolve1"
}

variable "subnet_id" {
  description = "The ID of the subnet"
}

variable "security_group_id" {
  description = "The ID of the security group"
}

