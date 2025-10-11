#!/bin/bash

MARKER_FILE="/etc/web_provisioned"

if [ -f "$MARKER_FILE" ]; then
  echo "Server already configured. Skipping..."
  exit 0
fi

echo "Updating system and installing Nginx..."
yum update -y
yum install -y nginx

systemctl enable nginx
systemctl start nginx

echo "<h1>Hello from Terraform Provisioner!</h1>" > /usr/share/nginx/html/index.html

touch "$MARKER_FILE"
echo "Provisioning complete."
