#!bin/bash
sudo dnf update -y
sudo dnf install httpd php -y
sudo systemctl enable httpd
sudo systemctl start httpd