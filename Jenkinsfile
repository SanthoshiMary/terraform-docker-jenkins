node {

    stage('Checkout') {
        checkout scm
    }

    stage('Check Tools') {
        bat 'terraform --version'
        bat 'docker --version'
        bat 'aws --version'
    }

    stage('Terraform Init') {
        dir('terraform') {
            bat 'terraform init'
        }
    }

    stage('Terraform Plan') {
        dir('terraform') {
            bat 'terraform plan'
        }
    }

    stage('Terraform Apply') {
        dir('terraform') {
            bat 'terraform apply -auto-approve'
        }
    }

    stage('Docker Build') {
        bat 'docker build -t terraform-docker-app .'
    }

    stage('Docker Login GHCR') {
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

    stage('Docker Push GHCR') {
        bat 'docker tag terraform-docker-app:latest ghcr.io/santhoshimary/terraform-docker-app:latest'
        bat 'docker push ghcr.io/santhoshimary/terraform-docker-app:latest'
    }
}