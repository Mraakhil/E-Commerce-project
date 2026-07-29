pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('accesskey')
        AWS_SECRET_ACCESS_KEY = credentials('secretaccesskey')
    }

    parameters {
        string(name: 'region', defaultValue: 'ap-south-1', description: 'AWS Region')
        string(name: 'cluster', defaultValue: 'my-eks-cluster', description: 'EKS Cluster Name')
    }

    stages {
        stage('update kubeconfig') {
            steps {
                sh "aws eks update-kubeconfig --region ${params.region} --name ${params.cluster}"
            }
        }
     stages {
        stage('repo update') {
            steps {
                sh "helm repo add E-COMMERCE-PROJECT https://github.com/Mraakhil/E-Commerce-project.git"
            }
        }    
        stage('helm update chart') {
            steps {
                sh 'helm repo update'
                sh 'helm upgrade --install frontend E-COMMERCE-PROJECT'
            }
        }
    }
}