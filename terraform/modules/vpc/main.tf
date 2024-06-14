resource "aws_vpc" "ivolve-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "ivolve-vpc"
  }
}

