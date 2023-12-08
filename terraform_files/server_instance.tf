# Specify the AWS provider
provider "aws" {
  region = "ap-southeast-1"  # Change to your AWS region
}

# Reference existing VPC and subnet variables
data "aws_vpc" "Testing-VPC" {
  id = "vpc-d98a69bf"  # Change to your VPC ID
}

data "aws_subnet" "TBD-private" {
  id = "subnet-09cb4f1f76fe369b9"  # Change to your subnet ID
}

variable "security_group_id" {
  type    = string
  default = "sg-03d0fc9fef31c5b9f"
}

data "aws_security_group" "To_Be_Deleted_Open" {
  id = var.security_group_id  # Change to your Security Group ID
}

# Create EC2 instances for your servers
resource "aws_instance" "server_terraform" {
  count         = 3
  ami           = "ami-078c1149d8ad719a7"  # Change to your AMI ID
  instance_type = "t2.micro"
  subnet_id     = "subnet-09cb4f1f76fe369b9"
  key_name      = "To_Be_Deleted_Singapore"  # Name of your key pair
  vpc_security_group_ids = [data.aws_security_group.To_Be_Deleted_Open.id]
  tags = {
    Name = "server_terraform_${count.index + 1}"
  }
}
