pipeline {
    agent any

    stages {
        stage('Deploy') {
            steps {
                sh '''
                    docker compose -f docker-compose.yml pull
                    docker compose -f docker-compose.yml up -d --remove-orphans
                    docker compose -f docker-compose.yml ps
                '''
            }
        }
    }
}
