pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('accesskey')
        AWS_SECRET_ACCESS_KEY = credentials('secretaccesskey')
    }
     parameters {
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')
        string(name: 'CLUSTER_NAME', defaultValue: 'my-eks-cluster', description: 'EKS Cluster Name')
    }

    stages {

        stage('Checkout') {
            steps {
                    sh "git branch: 'dev', url: 'https://github.com/Mraakhil/E-Commerce-project.git'"            }
        }

        stage('Update kubeconfig') {
            steps {
             
                    sh '''
                    aws eks update-kubeconfig \
                    --region $AWS_REGION \
                    --name $CLUSTER_NAME
                    '''
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

