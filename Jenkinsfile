pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t myapp .'
            }
        }
        stage('Test') {
            steps {
                // Run unit tests here
                sh 'npm test'
            }
        }
        stage('Deploy') {
            steps {
                // Push the Docker image to a container registry
                sh 'docker tag myapp myregistry/myapp:latest'
                sh 'docker push myregistry/myapp:latest'
            }
        }
    }
}
