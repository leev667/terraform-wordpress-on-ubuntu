# Terraform Output Values

# EC2 Instance Public IP
output "instance_publicip" {
  description = "EC2 Instance Public IP"
  value = [ for instance in aws_instance.semiramis2vm : instance.public_ip ]
}

# EC2 Instance Public DNS
output "instance_publicdns" {
  description = "EC2 Instance Public DNS"
  value = [ for instance in aws_instance.semiramis2vm : instance.public_dns ]
}
