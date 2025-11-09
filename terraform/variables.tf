variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ami_id" {
  default = "ami-0dee22c13ea7a9a67" # Amazon Linux 2 (Mumbai region)
}

variable "ecr_repo" {
  default = "130358282811.dkr.ecr.ap-south-1.amazonaws.com/roadmap-app"
}
