pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Tools') {
            steps {
                bat 'terraform --version'
                bat 'docker --version'
                bat 'aws --version'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t terraform-docker-app .'
            }
        }

        stage('Docker Login GHCR') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'ghcr-credentials',
                        usernameVariable: 'GHCR_USER',
                        passwordVariable: 'GHCR_TOKEN'
                    )
                ]) {
                    bat 'echo %GHCR_TOKEN% | docker login ghcr.io -u %GHCR_USER% --password-stdin'
                }
            }
        }

        stage('Docker Push GHCR') {
            steps {
                bat 'docker tag terraform-docker-app:latest ghcr.io/santhoshimary/terraform-docker-app:latest'
                bat 'docker push ghcr.io/santhoshimary/terraform-docker-app:latest'
            }
        }
    }
}git 