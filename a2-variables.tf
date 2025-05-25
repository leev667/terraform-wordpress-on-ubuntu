# Input Variables
# AWS Region
variable "aws_region" {
description = "Region in which AWS Resources are to be created"
type =  string 
default = "eu-west-2"
}

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t2.micro"  
}

# AWS EC2 Instance Key Pair
variable "instance_keypair" {
  description = "AWS EC2 Key Pair that is associated with the EC2 Instance"
  type = string
  default = "terraform-key"  
}
