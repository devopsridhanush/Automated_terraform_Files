data "aws_instance" "client_terraform" {
  instance_id = "i-08021e9e06d27047a"
}

resource "null_resource" "install_packer" {
  triggers = {
    instance_id = data.aws_instance.client_terraform.id
  }

  provisioner "local-exec" {
    command = "ssh -i /home/ubuntu/keys/To_Be_Deleted_Singapore.pem ${data.aws_instance.client_terraform.private_ip} 'bash -s' < /home/ubuntu/install_scripts/packer.sh"
  }
}
