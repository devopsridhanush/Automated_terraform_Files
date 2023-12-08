
# Specify the AWS provider
provider "aws" {
  region = "ap-southeast-1"  # Change to your AWS region
}

# Reference existing VPC and subnet
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

# Template files for service unit files
data "template_file" "consul_service" {
  template = file("/home/ubuntu/terra_scripts/consul.service")
}

data "template_file" "nomad_service" {
  template = file("/home/ubuntu/terra_scripts/nomad.service")
}

data "template_file" "traefik_service" {
  template = file("/home/ubuntu/terra_scripts/traefik.service")
}

data "template_file" "nomad_agent_config" {
  template = file("/home/ubuntu/terra_scripts/nomad_agent.json")
}

data "template_file" "nomad_acl_config" {
  template = file("/home/ubuntu/terra_scripts/nomad_acl.hcl")
}

data "template_file" "consul_agent_config" {
  template = file("/home/ubuntu/terra_scripts/consul_agent.json")
}

data "template_file" "consul_acl_config" {
  template = file("/home/ubuntu/terra_scripts/consul_acl.json")
}

data "template_file" "consul_connect_config" {
  template = file("/home/ubuntu/terra_scripts/consul_connect.json")
}

data "template_file" "consul_tls_config" {
  template = file("/home/ubuntu/terra_scripts/consul_tls.json")
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

    user_data = <<-EOF
  #!/bin/bash
  echo '${base64encode(data.template_file.consul_service.rendered)}' | base64 --decode > /etc/systemd/system/consul.service
  echo '${base64encode(data.template_file.nomad_service.rendered)}' | base64 --decode > /etc/systemd/system/nomad.service
  echo '${base64encode(data.template_file.traefik_service.rendered)}' | base64 --decode > /etc/systemd/system/traefik.service
  systemctl daemon-reload
  systemctl enable consul.service nomad.service traefik.service
  systemctl start consul.service nomad.service traefik.service
  bash -c "$(echo -e '${file("/home/ubuntu/dcn.sh")}')"
  echo '${base64encode(data.template_file.consul_agent_config.rendered)}' | base64 --decode > /etc/consul.d/agent.json
  echo '${base64encode(data.template_file.consul_acl_config.rendered)}' | base64 --decode > /etc/consul.d/acl.json
  echo '${base64encode(data.template_file.consul_connect_config.rendered)}' | base64 --decode > /etc/consul.d/connect.json
  echo '${base64encode(data.template_file.consul_tls_config.rendered)}' | base64 --decode > /etc/consul.d/tls.json
  echo '${base64encode(data.template_file.nomad_agent_config.rendered)}' | base64 --decode > /etc/nomad.d/agent.json
  echo '${base64encode(data.template_file.nomad_acl_config.rendered)}' | base64 --decode > /etc/nomad.d/acl.hcl
  EOF
}

# Attach the instances to the target group
resource "aws_lb_target_group_attachment" "traefik_testing" {
  count            = length(aws_instance.server_terraform.*.id)
  target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:514945254407:targetgroup/traefik-testing/79e585032c767c2f"  # Replace with your target group ARN
  target_id        = aws_instance.server_terraform[count.index].id
  port             = 443
}

# Create a Launch Template for your clients
resource "aws_launch_template" "client_terraform" {
  name          = "client-launch-template"
  image_id      = "ami-078c1149d8ad719a7"  # Change to your AMI ID
  instance_type = "t2.micro"
  key_name      = "To_Be_Deleted_Singapore"  # Name of your key pair
  vpc_security_group_ids = [data.aws_security_group.To_Be_Deleted_Open.id]

    user_data = base64encode(<<-EOF
  #!/bin/bash
  echo '${base64encode(data.template_file.consul_service.rendered)}' | base64 --decode > /etc/systemd/system/consul.service
  echo '${base64encode(data.template_file.nomad_service.rendered)}' | base64 --decode > /etc/systemd/system/nomad.service
  systemctl daemon-reload
  systemctl enable consul.service nomad.service
  systemctl start consul.service nomad.service
  bash -c "$(echo -e '${file("/home/ubuntu/dcn.sh")}')"
  EOF
  )

  # ... other configurations ...
}

# Create an Auto Scaling Group for your clients
resource "aws_autoscaling_group" "client_asg" {
  name                 = "client_asg"
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = ["subnet-09cb4f1f76fe369b9"]

  launch_template {
    id      = aws_launch_template.client_terraform.id
    version = aws_launch_template.client_terraform.latest_version
  }

  tag {
    key                 = "Name"
    value               = "client_terraform"
    propagate_at_launch = true
  }
  
  # ... other configurations ...
}

# ... additional configurations for Nomad, Consul, and Traefik ...


