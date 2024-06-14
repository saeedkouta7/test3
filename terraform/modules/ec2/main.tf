resource "aws_instance" "ivolve-ec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]

  root_block_device {
    volume_size = 20 
  }

  tags = {
    Name = "ivolve-ec2"
  }

  user_data = <<-EOF
    #cloud-config
    packages:
      - python3
      - python3-pip

    # Upgrade pip to latest version
    runcmd:
      - pip3 install --upgrade pip
  EOF
  }

