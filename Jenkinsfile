pipeline {
    agent any
    tools {
        jdk 'jdk17'
        // NodeJS plugin not installed, using system Node.js
    }
    environment {
        DOCKER_IMAGE = 'bookmyshow-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        K8S_NAMESPACE = 'bookmyshow-prod'
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/staragile2016/Book-My-Show.git'
                sh 'ls -la'
            }
        }
        
        stage('Build Application') {
            steps {
                sh '''
                echo "Using system Node.js: $(node --version)"
                cd bookmyshow-app
                npm install
                npm run build
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                '''
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                kubectl apply -f k8s/ingress.yaml
                kubectl rollout status deployment/bookmyshow-app
                '''
            }
        }
        
        stage('Verify Deployment') {
            steps {
                sh '''
                echo "Deployment verification:"
                kubectl get pods
                kubectl get services
                '''
            }
        }
    }
    post {
        success {
            echo '🎉 Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed! Check logs above.'
        }
    }
}
