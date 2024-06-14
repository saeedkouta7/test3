resource "aws_instance" "ivolve-ec2" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]

  root_block_device {
    volume_size = 20 
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y python3 python3-pip
    python3 -m pip install --upgrade pip
    pip install --upgrade ansible
    echo "Python and pip installed successfully"
  EOF

  tags = {
    Name = "ivolve-ec2"
  }
}

