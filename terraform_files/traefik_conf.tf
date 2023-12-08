data "aws_instance" "client_terraform" {
  instance_id = "i-0e60b5b85eef7285f"
}

resource "null_resource" "update_instance" {
  triggers = {
    instance_id = data.aws_instance.client_terraform.id
  }

  provisioner "local-exec" {
    command = <<EOT
        ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mkdir -p /etc/traefik.d'
        ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mkdir -p /etc/traefik.d/dyn'
        scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/traefik_config_files/traefik_static.toml ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/static.toml
        scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/traefik_config_files/traefik_dyn.toml ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/dyn.toml
        ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/static.toml /etc/traefik.d/static.toml && sudo chmod 644 /etc/traefik.d/static.toml'
        ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/dyn.toml /etc/traefik.d/dyn/dyn.toml && sudo chmod 644 /etc/traefik.d/dyn/*'
    EOT
  }
}
