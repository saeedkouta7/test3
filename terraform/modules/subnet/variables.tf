variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "availability_zone" {
  description = "List of availability zones to use for the subnets"
  default     = "us-east-1a"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}


