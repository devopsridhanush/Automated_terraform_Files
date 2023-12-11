# Specify the AWS provider
provider "aws" {
  region = "ap-southeast-1"  # Replace with your desired AWS region
}

variable "security_group_id" {
  type    = string
  default = "sg-03d0fc9fef31c5b9f"
}

data "aws_security_group" "To_Be_Deleted_Open" {
  id = var.security_group_id  # Change to your Security Group ID
}

# Define a Launch Template
resource "aws_launch_template" "client_terraform" {
  name          = "client-launch-template"
  description   = "client-launch-template"
  image_id      = "ami-078c1149d8ad719a7" # Change to your AMI ID
  instance_type = "t2.micro"
  key_name      = "To_Be_Deleted_Singapore"  # Name of your key pair
  vpc_security_group_ids = [data.aws_security_group.To_Be_Deleted_Open.id]
  # Add any other desired configuration for your launch template
}

# Define an Auto Scaling Group (ASG) and reference the Launch Template
resource "aws_autoscaling_group" "client_asg" {
  name                      = "client_asg"
  launch_template {
    id      = aws_launch_template.client_terraform.id
    version = aws_launch_template.client_terraform.latest_version
  }

  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  vpc_zone_identifier  = ["subnet-09cb4f1f76fe369b9"]  # Replace with your subnet IDs

  tag {
    key                 = "Name"
    value               = "client_terraform"
    propagate_at_launch = true
  }

  # Add any other ASG configuration you need
}
