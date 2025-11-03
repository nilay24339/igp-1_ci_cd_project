pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL = 'docker-key'
        DOCKER_REPO = 'nilay2497/myapp'
        PORT_MAPPING = '8081:8080'
        VENV_PATH = '/home/ubuntu/ansible-venv'
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/nilay24339/igp-1_ci_cd_project.git', branch: 'main'
            }
        }

        stage('Compile') { steps { sh 'mvn clean compile' } }
        stage('Test') { steps { sh 'mvn test' } }
        stage('Package') { steps { sh 'mvn package' } }

        stage('Docker Build') {
            steps {
                script {
                    def appImage = docker.build("${DOCKER_REPO}:${env.BUILD_ID}", ".")
                    env.DOCKER_IMAGE = "${DOCKER_REPO}:${env.BUILD_ID}"
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIAL}") {
                        docker.image(env.DOCKER_IMAGE).push('latest')
                    }
                }
            }
        }

        stage('Docker Run') {
            steps {
                script {
                    sh "docker rm -f myapp-container || true"
                    docker.image(env.DOCKER_IMAGE).run("-d -p ${PORT_MAPPING} --name myapp-container")
                }
            }
        }

        stage('Deploy via Ansible to Kubernetes') {
            steps {
                script {
                    // Activate venv and export KUBECONFIG for Ansible
                    sh '''
                        set -e
                        . ${VENV_PATH}/bin/activate
                        export KUBECONFIG=${KUBECONFIG}
                        echo "Using Python: $(which python3)"
                        echo "Using KUBECONFIG: $KUBECONFIG"

                        ansible-playbook playbooks/docker-k8s-deploy.yml \
                            -i inventory/hosts.ini \
                            -e "docker_image=${DOCKER_IMAGE}" \
                            -e "ansible_python_interpreter=${VENV_PATH}/bin/python3"
                    '''
                    echo "✅ Deployment completed successfully!"
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    sh '''
                        echo "Checking Kubernetes pods status..."
                        kubectl get pods -n default --kubeconfig ${KUBECONFIG}
                        echo "Checking service accessibility..."
                        kubectl get svc -n default --kubeconfig ${KUBECONFIG}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment successful — your application is running in Minikube!"
        }
        failure {
            echo "❌ Deployment failed — please check the Ansible/Kubernetes permissions."
        }
        always {
            echo "Pipeline finished."
        }
    }
}

