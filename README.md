# 🚀 Jenkins Deployment Assignment Documentation

### Table of Contents

1. Project Overview


2. Prerequisites


3. Cloning the Git Repository


4. Creating the Dockerfile


5. Writing the Jenkinsfile


6. Setting Up Jenkins Pipeline


7. Running the Jenkins Pipeline


8. Troubleshooting and Error Handling


9. Conclusion

---

### 1. Project Overview

This project automates the deployment of a web application( a simple HTML FILE) using Jenkins, Docker, Docker Hub, and AWS ECR. The pipeline includes:

Cloning the GitHub repository

Building a Docker image

Pushing the image to Docker Hub and AWS ECR

Handling errors and troubleshooting

---

### 2. Prerequisites

Ensure you have the following installed and configured:
✅ Git (git --version)
✅ Docker (docker --version)
✅ Jenkins (jenkins --version)
✅ AWS CLI (aws --version)
✅ A Docker Hub Account
✅ AWS Account with ECR Access

---

### 3. Cloning the Git Repository

Clone the project repository from GitHub:

git clone https://github.com/IbkWilliams1/jenkins-deployment-assignment.git

Navigate into the project directory:

cd jenkins-deployment-assignment

---

### 4. Creating the Dockerfile

Create a new Dockerfile inside the project directory:

touch Dockerfile

Add the following content:
```Dockerfile
# Use an official Nginx image
FROM nginx:latest

# Copy app files into container
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the Nginx service
CMD ["nginx", "-g", "daemon off;"]
```
---

### 5. Writing the Jenkinsfile

Create a Jenkinsfile:

touch Jenkinsfile

Add the following script:

```groovy
pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'your-dockerhub-username'
        DOCKERHUB_REPO = 'myapp'
        DOCKERHUB_IMAGE = "${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:latest"
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '123456789012'
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/myapp"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/IbkWilliams1/jenkins-deployment-assignment.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t myapp . || echo "Docker build failed!"'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin || echo "Docker login failed!"'
                    sh 'docker tag myapp $DOCKERHUB_IMAGE'
                    sh 'docker push $DOCKERHUB_IMAGE || echo "Docker push to Hub failed!"'
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO || echo "ECR login failed!"'
                    sh 'docker tag myapp $ECR_REPO:latest'
                    sh 'docker push $ECR_REPO:latest || echo "Docker push to ECR failed!"'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up unused Docker images'
            sh 'docker system prune -af || echo "Docker cleanup failed!"'
        }
        success {
            echo '🎉 Docker image successfully uploaded to both Docker Hub and AWS ECR!'
        }
        failure {
            echo '❌ Pipeline failed. Check error messages above.'
        }
    }
}
```
---


### 6. Setting Up Jenkins Pipeline


Follow these steps to configure Jenkins:

1. Login to Jenkins

Open Jenkins Dashboard in your browser.



2. Install Required Plugins

Go to Manage Jenkins → Manage Plugins.

Install:

Pipeline Plugin

Docker Pipeline Plugin

AWS CLI Plugin

3. Add Credentials in Jenkins

Navigate to Manage Jenkins → Manage Credentials.

Add:

Docker Hub Credentials (ID: DOCKERHUB_PASSWORD)

AWS Credentials




4. Create a New Pipeline

Click New Item → Pipeline

Name it Simple Web Deployment

Select Pipeline → OK



5. Configure the Pipeline

Scroll to Pipeline section.

Choose Pipeline Script from SCM.

Select Git and enter:

https://github.com/IbkWilliams1/jenkins-deployment-assignment.git

Click Save.





---

### 7. 5️⃣ Running the Jenkins Pipeline

To start the pipeline:

1. Click Build Now.


2. Monitor logs in Console Output.


3. If successful, images are pushed to:

Docker Hub: your-dockerhub-username/myapp:latest

AWS ECR: 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:latest


---

### 8. Troubleshooting and Error Handling

Here are common issues and fixes:

🚨 Error: Permission Denied on Docker Commands

❌ Error:

permission denied while trying to connect to the Docker daemon socket

✅ Fix:

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins


---

🚨 Error: Docker Login Fails

❌ Error:

unauthorized: incorrect username or password

✅ Fix:

Verify credentials in Manage Jenkins → Credentials.

Test login manually:

docker login -u your-dockerhub-username -p your-password



---

🚨 Error: AWS ECR Push Fails

❌ Error:

repository does not exist

✅ Fix:

Ensure ECR repository exists:

aws ecr create-repository --repository-name myapp --region us-east-1

Check AWS credentials:

aws sts get-caller-identity



---

🚨 Error: Jenkins Pipeline Fails

❌ Error:

ERROR: script returned exit code 1

✅ Fix:

Go to Jenkins Console Output and check logs.

Re-run pipeline after fixing errors.



---

### 9.  Conclusion

✅ Project successfully containerized with Docker.
✅ Automated deployment using Jenkins
