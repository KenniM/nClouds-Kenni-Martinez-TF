module "security_groups" {
  source = "../security_groups"
}

resource "aws_launch_configuration" "kmTFlc" {
  name            = "kmTFlc"
  image_id        = data.aws_ami.amznLinux.id
  instance_type   = "t2.micro"
  key_name        = data.aws_key_pair.key_pair.key_name
  user_data       = <<EOF
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
EOF
  security_groups = [module.security_groups.sg_id]
  iam_instance_profile = data.aws_iam_instance_profile.s3_access_role.name

  lifecycle {
    create_before_destroy = true
  }
}
