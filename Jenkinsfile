pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr:'20'))
        timeout(time:30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }
    
    stages {
        stage('Check if Image already exists') {
            steps {
                script {
                    def status = sh(returnStatus: true, script: "make pull")
                    if (status == 0) {
                        echo '########################################'
                        echo '#####  DOCKER IMAGE ALREADY EXISTS #####'
                        echo '########################################'
                        currentBuild.result = 'UNSTABLE'
                        return
                    }
                    else {
                        echo 'Image does not exist! Continuing to next stage'
                        
                    }
                }
            }
        }
        stage('Build Image') {
            steps {
                script {
                    sh('git clone ssh://git@github.com:7999/mirage2012/lottery-system.git')
                    sh('make image')
                }
            }
        }
        stage('Scan Image for Vulnerability') {
            steps {
                script {
                    sh('make scan')
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    sh('make push')
                }
            }
        }

    }
}