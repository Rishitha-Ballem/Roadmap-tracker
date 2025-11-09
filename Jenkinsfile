pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO = "130358282811.dkr.ecr.ap-south-1.amazonaws.com/roadmap-app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Rishitha-Ballem/Roadmap-tracker.git'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t $ECR_REPO:$IMAGE_TAG ."
                }
            }
        }

        stage('ECR Login') {
            steps {
                script {
                    sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO"
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker push $ECR_REPO:$IMAGE_TAG"
                }
            }
        }

        stage('Terraform Deploy to EC2') {
            steps {
                dir("terraform/") {
                    sh """
                        terraform init
                        terraform apply -auto-approve
                    """
                }
            }
        }
    }
}
