#!/bin/bash

MARKER_FILE="/etc/jenkins_provisioned"

if [ -f "$MARKER_FILE" ]; then
  echo "Server already configured. Skipping..."
  exit 0
fi

echo "Updating system..."
yum update -y

echo "Installing Java (OpenJDK 11)..."
amazon-linux-extras enable java-openjdk11
yum install -y java-11-openjdk-devel

echo "Adding Jenkins repo..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

echo "Installing Jenkins..."
yum install -y jenkins

echo "Starting and enabling Jenkins..."
systemctl enable jenkins
systemctl start jenkins

# Optional: open firewall port 8080 for Jenkins (if needed)
# sudo firewall-cmd --permanent --add-port=8080/tcp
# sudo firewall-cmd --reload

echo "Provisioning complete."

touch "$MARKER_FILE"
