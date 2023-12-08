data "aws_instance" "client_terraform" {
  instance_id = "i-08021e9e06d27047a"
}

resource "null_resource" "update_instance" {
  triggers = {
    instance_id = data.aws_instance.client_terraform.id
  }

  provisioner "local-exec" {
    command = <<EOT
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo rm -f /etc/consul.d/*'
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/consul_config_files/consul_agent.json ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/agent.json
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/consul_config_files/consul_acl.json ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/acl.json
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/consul_config_files/consul_connect.json ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/connect.json
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/consul_config_files/consul_tls.json ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/tls.json
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/agent.json /etc/consul.d/agent.json && sudo chmod 644 /etc/consul.d/agent.json'
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/acl.json /etc/consul.d/acl.json'
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/connect.json /etc/consul.d/connect.json'
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/tls.json /etc/consul.d/tls.json && sudo chmod 644 /etc/consul.d/*'
    EOT
  }
}
