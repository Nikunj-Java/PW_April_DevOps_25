output "elk_instance_ip" {
    description = "The public IP address of the ELK instance"
    value       = aws_instance.elk.public_ip
  
}