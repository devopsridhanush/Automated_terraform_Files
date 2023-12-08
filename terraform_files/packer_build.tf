resource "null_resource" "packer" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "packer build /home/ubuntu/packer_build/build_packer.json"
  }
}

output "ami_id" {
  value = "${null_resource.packer.id}"
}
