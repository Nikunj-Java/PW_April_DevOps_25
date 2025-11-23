output "ec2_public_ip" {
  value = aws_instance.webserver.public_ip
}

output "s3_bucket" {
  value = aws_s3_bucket.codedeploy_bucket.bucket
}
