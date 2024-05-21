pipeline {
    agent any
    parameters {
        choice(name: 'TARGETOS', choices: ['arm', 'windows', 'macos', 'linux'], description: 'OS')
        choice(name: 'TARGETARCH', choices: ['amd64', 'arm64'], description: 'Architecture')
    }

    environment {
        GITHUB_TOKEN=credentials('astergam')
        REPO = 'https://github.com/astergam/kbot.git'
        BRANCH = 'main'
    }

    stages {

        stage('clone') {
            steps {
                echo 'Clone repo'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }

        stage('test') {
            steps {
                echo 'Test'
                sh "make test"
            }
        }

        stage('image') {
            steps {
                echo "Build an image for platform ${params.TARGETOS} for architecture ${params.TARGETARCH}"
                sh "make image-${params.TARGETOS} ${params.TARGETARCH}"
            }
        }

        stage('build') {
            steps {
                echo "Build binary for platform ${params.TARGETOS} for architecture ${params.TARGETARCH}"
                sh "make ${params.TARGETOS} ${params.TARGETARCH}"
            }
        }
       
        stage('login to GHCR') {
            steps {
                sh "echo $GITHUB_TOKEN_PSW | docker login ghcr.io -u $GITHUB_TOKEN_USR --password-stdin"
            }
        }

        stage('push image') {
            steps {
                sh "make -n ${params.TARGETOS} ${params.TARGETARCH} image push"
            }
        } 
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}