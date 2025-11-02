provider "aws" {
    region = "us-east-1"
}

#---- s3 bucket for logs-----
resource "aws_s3_bucket" "jenkins_logs" {
    bucket = "jenkins-cicd-logs-bucket-12345674532134567"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_enc" {
    bucket = aws_s3_bucket.jenkins_logs.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
  
}

#---- iam role for jenkins to write logs to s3 bucket -----
resource "aws_iam_role" "jenkins_s3_role" {
    name = "jenkins-s3-access-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
}   

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
    role       = aws_iam_role.jenkins_s3_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  

}

resource "aws_iam_instance_profile" "jenkins_profile" {
    name = "jenkins-ec2-instance-profile"
    role = aws_iam_role.jenkins_s3_role.name
  
}

resource "aws_security_group" "jenkins_sg" {
    name        = "jenkins-sg"
    description = "Allow HTTP and SSH traffic"
   

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#--- key pair-------
resource "aws_key_pair" "jenkins_key" {
    key_name   = "jenkins-key-pair"
    public_key = file("/mnt/c/Users/NEW/.ssh/id_rsa.pub")
}


#-----ec2 instance with jenkins installation------
resource "aws_instance" "jenkins_server" {
    ami                         = "ami-0ecb62995f68bb549" # Amazon Ubuntu AMI
    instance_type               = "t2.micro"
    key_name                    = aws_key_pair.jenkins_key.key_name
    iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name
    vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install openjdk-11-jdk -y
                wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
                sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
                sudo apt update -y
                sudo apt install jenkins -y
                sudo systemctl start jenkins
                sudo systemctl enable jenkins
                EOF

    tags = {
        Name = "Jenkins-Server"
    }
}

#--- cloudwatch log monitoring -----
resource "aws_cloudwatch_log_group" "jenkins_log_group" {
    name              = "/aws/jenkins/logs"
    retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "jenkins_log_stream" {
    name           = "jenkins-log-stream"
    log_group_name = aws_cloudwatch_log_group.jenkins_log_group.name
}

resource "aws_cloudwatch_log_metric_filter" "error_filter" {
    name           = "JenkinsErrorFilter"
    log_group_name = aws_cloudwatch_log_group.jenkins_log_group.name
    pattern        = "ERROR"

    metric_transformation {
        name      = "JenkinsErrorMetric"
        namespace = "JenkinsMetrics"
        value     = "1"
    }
  
}

resource "aws_cloudwatch_metric_alarm" "jenkins_alarm" {
  alarm_name          = "HighJenkinsErrors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "JenkinsErrorCount"
  namespace           = "JenkinsApp"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Trigger if Jenkins logs show too many errors"
  actions_enabled     = true
  alarm_actions       = [] # You can attach SNS topics here
}


#---- outputs -----
output "jenkins_url" {
    description = "URL to access Jenkins server"
    value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}