#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo apt install php libapache2-mod-php -y
sudo systemctl enable apache2
sudo systemctl enable libapache2-mod-php
sudo systemctl start apache2
sudo systemctl start libapache2-mod-php