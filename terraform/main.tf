terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

# Security Group - Allow HTTP + SSH
resource "aws_security_group" "roadmap_sg" {
  name        = var.sg_name
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

# EC2 Instance to run Docker app
resource "aws_instance" "roadmap_app" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.roadmap_sg.id]
  associate_public_ip_address = true

    user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              dnf update -y

              # Install docker + aws cli
              dnf install -y docker
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user

              # Install AWS CLI v2 if not present
              if ! command -v aws &> /dev/null
              then
                curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                unzip awscliv2.zip
                sudo ./aws/install
              fi

              # Login to ECR
              aws ecr get-login-password --region ap-south-1 \
              | docker login --username AWS --password-stdin 130358282811.dkr.ecr.ap-south-1.amazonaws.com

              # Pull and run container
              docker pull 130358282811.dkr.ecr.ap-south-1.amazonaws.com/roadmap-app:latest

              # Stop old containers (if redeploy)
              docker stop $(docker ps -q) || true
              docker rm $(docker ps -aq) || true

              # Run app
              docker run -d -p 80:80 130358282811.dkr.ecr.ap-south-1.amazonaws.com/roadmap-app:latest
              EOF

  tags = {
    Name = var.instance_name
  }
}
