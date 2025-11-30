pipeline {
    agent any

    environment {
        PATH      = "/bin:/usr/bin:/usr/local/bin:${env.PATH}"
        BUILD_DIR = "dist"      // React build output folder
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