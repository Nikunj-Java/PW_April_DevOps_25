#!/bin/bash

MARKER_FILE="/etc/web_provisioned"

if [ -f "$MARKER_FILE" ]; then
  echo "Server already configured. Skipping..."
  exit 0
fi

echo "Updating system..."
yum update -y

echo "Installing Nginx..."
amazon-linux-extras enable nginx1
yum install -y nginx

echo "Starting Nginx..."
systemctl enable nginx
systemctl start nginx

# Create index.html safely
mkdir -p /usr/share/nginx/html
echo "<h1>Hello from Terraform Provisioner!</h1>" > /usr/share/nginx/html/index.html

touch "$MARKER_FILE"
echo "Provisioning complete."
