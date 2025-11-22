pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
        EC2_HOST = 'ubuntu@ip-172-31-45-20'
        EC2_SSH_KEY = credentials('ec2-ssh-key')
        DOCKER_IMAGE = 'nestjs-app:latest'
        EMAIL_RECIPIENT = 'binaufsolutions@gmail.com'
    }

    stages {

// git say code uthaya ha 
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Ahmad-kodify/CICD-pipelines-using-jenkins-'
            }
        }

// project k lyay jo important libraries thy vo download key han 
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy on Ubuntu EC2') {
            steps {
                script {
                    sh """
                        ssh -i ${EC2_SSH_KEY} -o StrictHostKeyChecking=no ${EC2_HOST} '
                            sudo mkdir -p /var/www/nestapp
                        '

                        scp -i ${EC2_SSH_KEY} -o StrictHostKeyChecking=no -r . ${EC2_HOST}:/var/www/nestapp/

                        ssh -i ${EC2_SSH_KEY} -o StrictHostKeyChecking=no ${EC2_HOST} '
                            cd /var/www/nestapp
                            
                            sudo docker stop nestjs-app || true
                            sudo docker rm nestjs-app || true
                            sudo docker rmi ${DOCKER_IMAGE} || true

                            sudo docker build -t ${DOCKER_IMAGE} .

                            sudo docker run -d -p 3000:3000 --name nestjs-app ${DOCKER_IMAGE}
                        '
                    """
                }
            }
        }

        stage('Send Email Notification') {
            steps {
                emailext(
                    to: "${EMAIL_RECIPIENT}",
                    subject: "NestJS Deployment Success on Ubuntu EC2",
                    body: "Your NestJS app has been successfully deployed on Ubuntu EC2 at IP: ${EC2_HOST}"
                )
            }
        }
    }

    post {
        success {
            echo "Deployment Completed Successfully!"
        }
        failure {
            emailext(
                to: "${EMAIL_RECIPIENT}",
                subject: "Deployment Failed",
                body: "NestJS deployment failed. Please check Jenkins logs."
            )
        }
    }
}
