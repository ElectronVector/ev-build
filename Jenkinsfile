pipeline {
    agent { dockerfile true }
    stages {
        stage('Test') {
            steps {
                sh 'ceedling test:all'
            }
        }
    }
}