data "aws_instance" "client_terraform" {
  instance_id = "i-008443b4087cc6af2"
}

resource "null_resource" "update_instance" {
  triggers = {
    instance_id = data.aws_instance.client_terraform.id
  }

  provisioner "local-exec" {
    command = <<EOT
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo rm -f /etc/nomad.d/*'
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/nomad_config_files/nomad_agent.json ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/agent.json
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/nomad_config_files/nomad_acl.json ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/acl.json
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/agent.json /etc/nomad.d/agent.json'
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/acl.json /etc/nomad.d/acl.json && sudo chmod 644 /etc/nomad.d/*'
    EOT
  }
}
