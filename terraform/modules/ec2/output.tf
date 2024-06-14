output "public_ip" {
  value = aws_instance.ivolve-ec2.public_ip
}

output "instance_id" {
  value = aws_instance.ivolve-ec2.id
}

