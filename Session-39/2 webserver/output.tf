output "instance_public_ip" {
    description = "The Public IP address of the webserver"
    value = aws_instance.web.public_ip
  
}

output "instance_id" {
    description = "The ID of the webserver instance"
    value = aws_instance.web.id
  
}