#!/bin/bash

# Update system
sudo dnf update -y

# Install required packages
sudo dnf install -y ruby wget dnf-plugins-core

# Set region
REGION="ap-south-1"

# Download and Install CodeDeploy Agent
cd /home/ec2-user

wget https://aws-codedeploy-$REGION.s3.$REGION.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Enable and start CodeDeploy agent
sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent

# (Optional) Install Apache to verify EC2 running correctly
sudo dnf install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
echo "<h1>EC2 is running — CodeDeploy Agent Installed</h1>" > /var/www/html/index.html
