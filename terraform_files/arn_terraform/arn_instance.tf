provider "aws" {
  # Specify your AWS region
  region = "ap-southeast-1"  # e.g., "us-west-1"
}

# Specify your existing instance ID
variable "instance_id" {
  type = string
  default = "i-0dea034c5991757f1"  # Replace with your instance ID
}

# Directly specify the ARN of your target group
variable "target_group_arn" {
  type = string
  default = "arn:aws:elasticloadbalancing:ap-southeast-1:514945254407:targetgroup/traefik-testing/79e585032c767c2f"  # Replace with your target group ARN
}

# Attach each existing instance to the target group
resource "aws_lb_target_group_attachment" "traefik_testing" {
  target_group_arn = var.target_group_arn
  target_id        = var.instance_id
  port             = 443  # Replace with the port your target group is set up for (e.g., 80 for HTTP, 443 for HTTPS)
}


