output "ws_output_instance" {
  value = aws_instance.tomcat_server # in output call all parameters of this resource (type_resource.name_resource) later in main output will select from here id and IP
}