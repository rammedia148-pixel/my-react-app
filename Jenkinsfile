pipeline {
    agent any

    environment {
        NODE_VERSION = "18"       // change if needed
        BUILD_DIR = "dist"        // For Vite/React. Change to "build" if CRA.
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Pulling latest code..."
                git branch: 'master',          // <-- change branch (main/master/dev)
            url: 'https://github.com/rammedia148-pixel/my-react-app.git'
            }
        }

        // stage('Setup Node') {
        //     steps {
        //         echo "📦 Setting up Node.js..."
        //         sh "nvm install $NODE_VERSION"
        //         sh "nvm use $NODE_VERSION"
        //     }
        // }

        stage('Install Dependencies') {
            steps {
                echo "📦 Installing dependencies..."
                sh 'npm install'
            }
        }

        stage('Run Build') {
            steps {
                echo "🏗️ Running build..."
                sh 'npm run build'
            }
        }

        // stage('Archive Build Artifacts') {
        //     steps {
        //         echo "📦 Archiving build output..."
        //         archiveArtifacts artifacts: "${BUILD_DIR}/**", fingerprint: true
        //     }
        // }

        stage('Deploy') {
            steps {
                echo "🚀 Deploying build to server..."

                // UNCOMMENT one of the deploy methods below

                // ----------- OPTION 1: Deploy to CPanel via FTP ----------
                sh '''
                curl -T "${BUILD_DIR}/*" -u "ram@testing.vmvanigam.com:t([K+)k%wO(*MT)S" ftp://103.86.176.168/testing/
                '''

                // ----------- OPTION 2: Deploy via SSH/SFTP ---------------
                // sh '''
                // scp -r ${BUILD_DIR}/* user@server:/path/to/deploy/
                // '''

                // ----------- OPTION 3: Deploy to Nginx/Apache ------------
                // sh '''
                // rm -rf /var/www/html/*
                // cp -r ${BUILD_DIR}/* /var/www/html/
                // '''
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
