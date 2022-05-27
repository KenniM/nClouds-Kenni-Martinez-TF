#!/bin/bash
cd /home/ec2-user
mkdir deploy
cd deploy
aws s3 cp s3://kennim-bucket . --recursive
cd ../
sudo amazon-linux-extras enable epel
sudo yum install epel-release -y
sudo yum install nginx -y
cd /usr/share/nginx/html
sudo rm index.html
sudo rm -r icons
sudo rm -r img
cd /home/ec2-user/deploy
sudo cp -r * /usr/share/nginx/html
sudo systemctl start nginx.service