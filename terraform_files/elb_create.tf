provider "aws" {
  region = "ap-southeast-1"  # Update with your desired region
}

resource "aws_lb" "testing_terraform" {
  name               = "testing-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-03d0fc9fef31c5b9f"]
  subnets            = ["subnet-0440c35d", "subnet-7328fc15", "subnet-6ef03426"]
}

resource "aws_lb_listener" "listener_443" {
  load_balancer_arn = aws_lb.testing_terraform.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }

  certificate_arn = "arn:aws:acm:ap-southeast-1:514945254407:certificate/eef612a6-62d7-443e-a8a4-2cd8c38b6e10"
}

resource "aws_lb_listener" "listener_8080" {
  load_balancer_arn = aws_lb.testing_terraform.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "terra_target_group" {
  name     = "terra-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-d98a69bf"
}
