pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    parameters {
        string(
            name: 'AWS_REGION',
            defaultValue: 'ap-south-1',
            description: 'AWS Region'
        )

        string(
            name: 'CLUSTER_NAME',
            defaultValue: 'my-eks-cluster',
            description: 'EKS Cluster Name'
        )

        string(
            name: 'NAMESPACE',
            defaultValue: 'default',
            description: 'Kubernetes Namespace'
        )

        string(
            name: 'RELEASE_NAME',
            defaultValue: 'ecommerce',
            description: 'Helm Release Name'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('accesskey')
        AWS_SECRET_ACCESS_KEY = credentials('secretaccesskey')
        KUBECONFIG            = "${WORKSPACE}/kubeconfig"
        CHART_PATH            = "./ecommerce"
    }

    stages {

        stage('Checkout Source') {
            steps {
                git branch: 'prod',
                    url: 'https://github.com/Mraakhil/E-Commerce-project.git'
            }
        }

        stage('Verify Helm Chart') {
            steps {
                sh '''
                echo "Current Workspace:"
                pwd

                echo "Workspace Files:"
                ls -la

                echo "Chart Directory:"
                ls -la ${CHART_PATH}

                test -f ${CHART_PATH}/Chart.yaml

                helm lint ${CHART_PATH}
                '''
            }
        }

        stage('Update kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig \
                    --region ${AWS_REGION} \
                    --name ${CLUSTER_NAME} \
                    --kubeconfig ${KUBECONFIG}
                '''
            }
        }

        stage('Deploy Helm Chart') {
             steps {
                  sh '''
                  export KUBECONFIG=${KUBECONFIG}

                   helm upgrade --install ecommerce ./ecommerce \
                   --namespace ${NAMESPACE} \
                   --create-namespace \
                   --wait \
                   --timeout 10m \
                   --rollback-on-failure \
                   --kubeconfig ${KUBECONFIG} || true

                     echo "===== Pods ====="
                     kubectl --kubeconfig=${KUBECONFIG} get pods -A -o wide

                     echo "===== Deployments ====="
                     kubectl --kubeconfig=${KUBECONFIG} get deployments -A

                     echo "===== Events ====="
                     kubectl --kubeconfig=${KUBECONFIG} get events -A --sort-by=.metadata.creationTimestamp
                     '''
             }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl get all -n ${NAMESPACE}

                echo "--------------------------------"

                helm list -n ${NAMESPACE}

                echo "--------------------------------"

                helm status ${RELEASE_NAME} -n ${NAMESPACE}
                '''
            }
        }
    }

    post {

        success {
            echo 'Deployment completed successfully.'
        }

        failure {
            sh '''
            echo "===== Workspace ====="
            pwd

            echo "===== Chart Files ====="
            find . -name Chart.yaml

            echo "===== Helm Version ====="
            helm version || true

            echo "===== Kubernetes Nodes ====="
            kubectl get nodes || true

            echo "===== Pods ====="
            kubectl get pods -A || true
            '''
        }

        always {
            cleanWs()
        }
    }
}