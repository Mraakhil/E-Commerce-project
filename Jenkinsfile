pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('accesskey')
        AWS_SECRET_ACCESS_KEY = credentials('secretaccesskey')
        AWS_REGION            = "${params.AWS_REGION}"
        CLUSTER_NAME          = "${params.CLUSTER_NAME}"
        KUBECONFIG            = "${WORKSPACE}/kubeconfig"
    }

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')
        string(name: 'CLUSTER_NAME', defaultValue: 'my-eks-cluster', description: 'EKS Cluster Name')
    }

    stages {
        stage('GIT Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/Mraakhil/E-Commerce-project.git'
            }
        }

        stage('Update kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig \
                  --region $AWS_REGION \
                  --name $CLUSTER_NAME \
                  --kubeconfig $KUBECONFIG
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

    post {
        always {
            cleanWs()
        }
    }
}