pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        CLUSTER_NAME = "my-eks-cluster"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Update kubeconfig') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials']
                ]) {
                    sh '''
                    aws eks update-kubeconfig \
                    --region $AWS_REGION \
                    --name $CLUSTER_NAME
                    '''
                }
            }
        }

        stage('Deploy Helm Chart') {
            steps {
                sh '''
                helm upgrade --install ecommerce . \
                  --namespace default \
                  --create-namespace
                '''
            }
        }
    }
}