output "ec2_public_ip" { #print in output public IP of ec2 instance for SSH connection
  # value = module.name_module_myapp_webserver.ws_output_instance.public_ip #select from output of module "webserver" IP of instance 
  #* value = module.name_module_myapp_webserver.ws_output_instance #рабочий вариант, но выводит все подряд
  # value = [for i in module.name_module_myapp_webserver.ws_output_instance : i.public_ip] #This value does not have any attributes.
  # value = module.name_module_myapp_webserver.ws_output_instance.public_ip[0] #is tuple with 1 element
  # value = tolist(module.name_module_myapp_webserver.ws_output_instance[0].public_ip) #is tuple with 2 elements
  value = [for i in module.name_module_myapp_webserver.ws_output_instance[0] : i.public_ip]

}

# output "aws_ami_id" { #check in output number of id created instance
#   value = module.name_module_myapp_webserver.ws_output_instance.id
# }
