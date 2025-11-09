variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of your EC2 key pair"
  type        = string
  default     = "ec2_Rishi"
}

variable "ecr_repo" {
  description = "AWS ECR Repository URI"
  type        = string
  default     = "130358282811.dkr.ecr.ap-south-1.amazonaws.com/roadmap-app"
}

variable "sg_name" {
  description = "Security Group Name"
  type        = string
  default     = "roadmap-sg"
}

variable "instance_name" {
  description = "Instance Name Tag"
  type        = string
  default     = "roadmap-app-server"
}
