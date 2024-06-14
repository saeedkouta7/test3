resource "aws_internet_gateway" "ivolve-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "ivolve-igw"
  }
}

