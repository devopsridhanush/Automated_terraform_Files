provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_ami_from_instance" "example" {
  name               = "ami-from-instance-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  source_instance_id = "i-0e60b5b85eef7285f"  // Replace with your source instance ID in Singapore region
  snapshot_without_reboot = true

  tags = {
    Name = "MyCustomAMI"
  }
}
