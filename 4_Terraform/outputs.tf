output "public_ip_jenkins_docker" {                                                                           #print in output public IP of ec2 instance for SSH connection
  value = [for i in module.name_module_myapp_webserver.ws_output_public_instance[0] : i.public_ip] #If several servers are created, then the IP of each of the data array is shown 
}
output "private_ip_jenkins_docker" { #print in output private IP of ec2 instance
  value = [for i in module.name_module_myapp_webserver.ws_output_public_instance[0] : i.private_ip]
}
output "private_ip_ansible" { #print in output private IP of ec2 instance
  value = [for i in module.name_module_myapp_webserver.ws_output_private_instance[0] : i.private_ip]
}