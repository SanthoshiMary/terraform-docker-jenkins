# Terraform-Docker-Jenkins: AWS DevOps Pipeline

## Project Overview

This project demonstrates a DevOps workflow using **GitHub, Jenkins, Terraform, AWS EC2, Docker, and GitHub Container Registry (GHCR)**.

The pipeline automates infrastructure provisioning and Docker image building and publishing. The Docker image is then manually pulled and run on an EC2 instance to verify the application.

## Technologies Used

- **GitHub** – Source code management and version control
- **Jenkins** – CI/CD pipeline automation
- **Terraform** – Infrastructure as Code (IaC)
- **AWS EC2** – Cloud virtual machines
- **Amazon VPC** – Network isolation and configuration
- **Docker** – Containerization
- **GitHub Container Registry (GHCR)** – Docker image storage
- **Node.js** – Application runtime

## Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    v
Jenkins Pipeline
    |
    +----------------------+
    |                      |
    v                      v
Terraform              Docker Build
    |                      |
    v                      v
AWS Infrastructure    GitHub Container Registry
    |                      |
    v                      v
VPC + 2 Public        Manual Image Pull
Subnets + 2 EC2              |
Instances                    v
                       Docker Container
                         on EC2-1
                              |
                              v
                       Web Browser
```

## Project Features

- Automated AWS infrastructure provisioning using Terraform
- Creation of a custom VPC with CIDR block `11.0.0.0/16`
- Two public subnets in different Availability Zones
- Two EC2 instances with Docker installed through Terraform `user_data`
- Jenkins pipeline integrated with GitHub
- Automated Docker image build and push to GHCR
- Manual Docker image pull and container execution on EC2-1
- Browser-based application verification

## AWS Infrastructure

| Resource | Configuration |
|---|---|
| AWS Region | `ap-south-1` (Mumbai) |
| VPC CIDR | `11.0.0.0/16` |
| Public Subnet 1 | `11.0.1.0/24` |
| Public Subnet 2 | `11.0.2.0/24` |
| EC2 Instance Type | `t2.micro` |
| Operating System | Ubuntu |
| Container Port | `8080` |

Terraform manages the VPC, internet gateway, public subnets, route table, security group, and two EC2 instances.

## Repository Structure

```text
terraform-docker-jenkins/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── versions.tf
│
├── app.js
├── Dockerfile
├── Jenkinsfile
└── README.md
```

*Note: The exact files inside the `terraform` directory may vary depending on your implementation.*

## Application Details

The application is a simple Node.js HTTP server that returns a text response.

**Expected output:**

```text
Hello from Docker on AWS EC2!
```

The application listens on port `8080` inside the Docker container.

## Jenkins Pipeline Workflow

The Jenkins pipeline performs the following stages:

1. **Checkout:** Retrieves source code from GitHub.
2. **Tool Verification:** Checks the required tools.
3. **Terraform Init:** Initializes the Terraform working directory and backend.
4. **Terraform Plan:** Checks the proposed infrastructure changes.
5. **Terraform Apply:** Provisions the AWS infrastructure.
6. **Docker Build:** Builds the application image.
7. **Docker Login:** Authenticates with GitHub Container Registry using Jenkins credentials.
8. **Docker Push:** Publishes the image to GHCR.

The pipeline does not automatically deploy or start the application container on EC2. Image pulling and container execution are performed manually.

## Running the Application on EC2

### 1. Connect to EC2-1 using SSH

```bash
ssh -i "terraform-docker-key.pem" ubuntu@<EC2_PUBLIC_IP>
```

Replace `<EC2_PUBLIC_IP>` with the public IP of your EC2 instance.

### 2. Log in to GitHub Container Registry

Use a GitHub Personal Access Token with the necessary package permissions. Never commit the token to the repository.

```bash
echo "$GHCR_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

Set `GHCR_TOKEN` securely in your terminal before running the command.

### 3. Pull the Docker image

```bash
docker pull ghcr.io/santhoshimary/terraform-docker-app:latest
```

### 4. Run the container

```bash
docker run -d --name terraform-docker-container -p 8080:8080 ghcr.io/santhoshimary/terraform-docker-app:latest
```

### 5. Verify the container

```bash
docker ps
```

### 6. Access the application

Open the following URL in a browser:

```text
http://<EC2_PUBLIC_IP>:8080
```

The browser should display:

```text
Hello from Docker on AWS EC2!
```

## Security Considerations

- Store AWS credentials in Jenkins Credentials rather than source code.
- Store GitHub access tokens securely.
- Do not commit PEM private keys, access keys, secret keys, or tokens.
- Restrict inbound security group rules to trusted IP addresses where possible.
- Use least-privilege IAM permissions for production deployments.
- Review AWS resources after testing to avoid unnecessary charges.

## Learning Outcomes

Through this project, I gained practical experience with:

- Infrastructure as Code using Terraform
- AWS networking and EC2 provisioning
- Jenkins pipeline creation and execution
- Docker image building and container execution
- GitHub Container Registry integration
- SSH-based access to cloud instances
- End-to-end DevOps workflow implementation

## Conclusion

This project demonstrates how infrastructure provisioning and container image publishing can be automated using Terraform and Jenkins. It also shows how a containerized Node.js application can be manually deployed to an AWS EC2 instance and verified through a web browser.
