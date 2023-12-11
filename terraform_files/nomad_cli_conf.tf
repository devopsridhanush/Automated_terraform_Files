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
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/nomad_client_config_files/nomad_agent.json ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/agent.json
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/nomad_client_config_files/nomad_plugin.hcl ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/plugin.hcl
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/agent.json /etc/nomad.d/agent.json'
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/plugin.hcl /etc/nomad.d/plugin.hcl && sudo chmod 644 /etc/nomad.d/*'
    EOT
  }
}
