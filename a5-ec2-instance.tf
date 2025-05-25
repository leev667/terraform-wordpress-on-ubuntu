# EC2 Instance
resource "aws_instance" "semiramis2vm" {
  ami = "ami-0a94c8e4ca2674d5a"
  instance_type = var.instance_type
  count = 1
  user_data = file("${path.module}/lamp-wordpres-ubuntu-24.sh")
  key_name = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id ]
  tags = {
    "Name" = "Semiramis Instance-${count.index}"
  }
}
