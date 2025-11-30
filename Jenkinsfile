pipeline {
    agent any

    environment {
        PATH      = "/bin:/usr/bin:/usr/local/bin:${env.PATH}"
        BUILD_DIR = "dist"      // React build output folder
        IMAGE_NAME = "react-app"
        CONTAINER_NAME = "react-app-container"
        HOST_PORT = "8081"
        CONTAINER_PORT = "3000" // must match EXPOSE / serve -l in Dockerfile
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                git credentialsId: 'rammedia148-pixel', url: 'https://github.com/rammedia148-pixel/my-react-app.git'
            }
        }

        stage('Node & NPM Info') {
            steps {
                sh '''
                    echo "Using PATH: $PATH"
                    node -v
                    npm -v
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    echo "Cleaning previous installs..."
                    rm -rf node_modules package-lock.json

                    echo "Installing npm dependencies..."
                    npm install
                '''
            }
        }

        stage('Build App') {
            steps {
                sh '''
                    echo "Building the project..."
                    npm run build
                    echo "Listing workspace after build:"
                    ls -al
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Deploying build to server..."

                // Use Jenkins credentials (add them in Jenkins → Credentials, e.g. ID: cpanel-ftp)
                withCredentials([usernamePassword(credentialsId: 'cpanel-ftp', usernameVariable: 'FTP_USER', passwordVariable: 'FTP_PASS')]) {
                    sh '''
                        echo "Zipping build directory..."
                        rm -f app.zip
                        cd "${BUILD_DIR}"
                        zip -r ../app.zip .

                        echo "Uploading app.zip via FTP..."
                        cd ..
                        curl -T "app.zip" -u "${FTP_USER}:${FTP_PASS}" "ftp://103.86.176.168:21/app.zip"
                    '''
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    echo "=== Building Docker Image ==="
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                    echo "=== Removing old container if it exists ==="
                    docker rm -f ${CONTAINER_NAME} || true

                    echo "=== Running new container ==="
                    docker run -d \
                      -p ${HOST_PORT}:${CONTAINER_PORT} \
                      --name ${CONTAINER_NAME} \
                      ${IMAGE_NAME}:${BUILD_NUMBER}

                    echo "=== Currently running containers ==="
                    docker ps
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build and deploy completed successfully."
        }
        failure {
            echo "❌ Build or deploy failed. Check logs above."
        }
    }

}
