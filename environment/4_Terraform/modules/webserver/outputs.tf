output "ws_output_private_instance" {
  value = [aws_instance.cicd_private_server] # in output call all parameters of this resource (type_resource.name_resource) later in main output will select from here id and IP
}
output "ws_output_public_instance" {
  value = [aws_instance.cicd_public_server] # in output call all parameters of this resource (type_resource.name_resource) later in main output will select from here id and IP
}
