output "ec2_public_ip" { #print in output public IP of ec2 instance for SSH connection
  value = module.name_module_myapp_webserver.ws_output_instance.public_ip #select from output of module "webserver" IP of instance 
}

output "aws_ami_id" {                               #check in output number of id created instance
  value = module.name_module_myapp_webserver.ws_output_instance.id 
}