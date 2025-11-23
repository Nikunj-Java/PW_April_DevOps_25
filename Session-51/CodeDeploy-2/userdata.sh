#!/bin/bash
sudo dnf update -y
sudo dnf install -y ruby wget

REGION="ap-south-1"

cd /home/ec2-user
wget https://aws-codedeploy-$REGION.s3.$REGION.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent
