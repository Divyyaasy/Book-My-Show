pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "bookmyshow-app"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/staragile2016/Book-My-Show.git'
                sh 'ls -la'
            }
        }
        
        stage('Build React App') {
            steps {
                sh '''
                echo "🔨 BUILDING REACT APPLICATION"
                cd bookmyshow-app
                
                # Clean and install
                rm -rf node_modules package-lock.json build
                echo "legacy-peer-deps=true" > .npmrc
                echo "audit=false" >> .npmrc
                
                # Install with compatible versions
                npm install react-scripts@4.0.3 --save
                npm install --legacy-peer-deps --force
                
                # Build
                CI=false npm run build
                
                # Verify build
                if [ ! -d "build" ]; then
                    echo "❌ React build failed"
                    exit 1
                else
                    echo "✅ React build successful"
                    echo "Build size: \$(du -sh build)"
                fi
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh '''
                echo "🐳 BUILDING DOCKER IMAGE"
                
                # Build Docker image
                docker build --no-cache -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                
                echo "✅ Docker image built successfully"
                docker images | grep ${DOCKER_IMAGE}
                '''
            }
        }
        
        stage('Test Container') {
            steps {
                sh '''
                echo "🧪 TESTING DOCKER CONTAINER"
                
                # Find available port
                PORT=9099
                while netstat -tulpn | grep :$PORT >/dev/null; do
                    PORT=$((PORT + 1))
                done
                
                # Run test container
                docker run -d --name test-${BUILD_NUMBER} -p $PORT:3000 ${DOCKER_IMAGE}:${BUILD_NUMBER}
                sleep 5
                
                # Test health endpoint
                if curl -s http://localhost:$PORT/api/health | grep -q "OK"; then
                    echo "✅ Container test passed"
                else
                    echo "❌ Container test failed"
                    docker logs test-${BUILD_NUMBER}
                    exit 1
                fi
                
                # Cleanup
                docker stop test-${BUILD_NUMBER}
                docker rm test-${BUILD_NUMBER}
                '''
            }
        }
    }
    
    post {
        always {
            sh '''
            echo "🧹 Cleaning up..."
            docker system prune -f || true
            rm -rf bookmyshow-app/node_modules bookmyshow-app/build || true
            '''
        }
        success {
            echo '🎉 🎉 🎉 PIPELINE SUCCESSFUL! 🎉 🎉 🎉'
        }
        failure {
            echo '❌ ❌ ❌ PIPELINE FAILED! ❌ ❌ ❌'
        }
    }
}
