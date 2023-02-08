output "public_ip_jenkins_docker" {                                                                #print in output public IP of ec2 instance for SSH connection
  value = [for i in module.name_module_myapp_webserver.ws_output_public_instance[0] : i.public_ip] #If several servers are created, then the IP of each of the data array is shown 
}
output "private_ip_jenkins_docker" { #print in output private IP of ec2 instance
  value = [for i in module.name_module_myapp_webserver.ws_output_public_instance[0] : i.private_ip]
}
output "private_ip_ansible" { #print in output private IP of ec2 instance
  value = [for i in module.name_module_myapp_webserver.ws_output_private_instance[0] : i.private_ip]
}


locals {
  host_private = [for i in range(0, length(module.name_module_myapp_webserver.ws_output_public_instance[0])) : { "name" : "private_${i}", "ip" : module.name_module_myapp_webserver.ws_output_public_instance[0][i].private_ip }]
  host_public  = [for i in range(0, length(module.name_module_myapp_webserver.ws_output_public_instance[0])) : { "name" : "public_${i}", "ip" : module.name_module_myapp_webserver.ws_output_public_instance[0][i].public_ip }]
}

locals {
  private_ips = "${join("\n", [for i in local.host_private : "${i.name} ansible_host=${i.ip}"])}\n"
  public_ips  = "${join("\n", [for i in local.host_public : "${i.name} ansible_host=${i.ip}"])}\n"
}

resource "local_file" "inventory" {
  content  = <<EOF
${local.private_ips}

${local.public_ips}

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=~/.ssh/aws   
  EOF
  filename = pathexpand("~/Downloads/5_Ansible/inventory.ini")
}
