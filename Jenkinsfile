pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL = 'docker-key'
        DOCKER_REPO = 'nilay2497/myapp'
        PORT_MAPPING = '8081:8080'
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/nilay24339/igp-1_ci_cd_project.git', branch: 'main'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

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
                        def image = docker.image(env.DOCKER_IMAGE)
                        image.push('latest')
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
    }

    post {
        always {
            echo "Pipeline finished."
        }
    }
}

