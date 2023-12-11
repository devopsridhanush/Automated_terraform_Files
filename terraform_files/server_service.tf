data "aws_instance" "client_terraform" {
  instance_id = "i-08021e9e06d27047a"
}

resource "null_resource" "update_instance" {
  triggers = {
    instance_id = data.aws_instance.client_terraform.id
  }

  provisioner "local-exec" {
    command = <<EOT
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/service_scripts/consul.service ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/consul.service
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/service_scripts/nomad.service ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/nomad.service
      scp -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem /home/ubuntu/service_scripts/traefik.service ubuntu@${data.aws_instance.client_terraform.private_ip}:/tmp/traefik.service
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/consul.service /etc/systemd/system/consul.service && sudo chmod 644 /etc/systemd/system/consul.service'
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/nomad.service /etc/systemd/system/nomad.service' && sudo chmod 644 /etc/systemd/system/nomad.service'
      ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ubuntu@${data.aws_instance.client_terraform.private_ip} 'sudo mv /tmp/traefik.service /etc/systemd/system/traefik.service' && sudo chmod 644 /etc/systemd/system/traefik.service'
    EOT
  }
}
