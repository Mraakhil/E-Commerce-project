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
        string(name: 'NAMESPACE', defaultValue: 'default', description: 'Kubernetes namespace to deploy into')
        string(name: 'CHART_PATH', defaultValue: './ecommerce/Chart.yaml', description: 'Path to the Helm chart directory (relative to repo root).')
    }

    stages {

        stage('GIT Checkout') {
            steps {
                git branch: 'prod', url: 'https://github.com/Mraakhil/E-Commerce-project.git'
            }
        }

        stage('Locate Helm Chart') {
            steps {
                sh '''
                echo "Searching for Chart.yaml in the workspace..."
                find . -name "Chart.yaml" -not -path "*/node_modules/*"
                '''
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
                helm upgrade --install ecommerce ${CHART_PATH} \
                  --namespace ${NAMESPACE} \
                  --create-namespace \
                  --rollback-on-failure \
                  --timeout 5m
                '''
            }
        }

        stage('Verify Rollout') {
            steps {
                sh '''
                kubectl get pods -n ${NAMESPACE}
                helm status ecommerce -n ${NAMESPACE}
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo 'Deployment failed. Check the "Locate Helm Chart" stage output above to confirm CHART_PATH is correct.'
        }
    }
}