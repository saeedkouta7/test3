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

    # Update package lists (adjust based on your distro)
    apt-get update

    # Install python3-six library
    apt-get install -y python3-six

    # (Optional) Install Ansible for further configuration
    # apt-get install -y ansible
    echo "Python and pip installed successfully"
  EOF

  tags = {
    Name = "ivolve-ec2"
  }
}

