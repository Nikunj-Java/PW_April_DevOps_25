#!/bin/bash

MARKER_FILE="/etc/web_provisioned"

if[-f "$MARKER_FILE"]; then
    echo "Server already configured. skipping..."
    exit 0
fi

echo "Updating System and Initializing Nginx...."
yum update -y 
yum install -y nginx

systemctl enable nginx
systemctl start nginx

echo "<h1>Hello from Terraform Provisioner</h1>" > /usr/share/nginx/index.html

touch "$MARKER_FILE"
echo "provisioning complete!"