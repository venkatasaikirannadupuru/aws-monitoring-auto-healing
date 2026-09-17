pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'DESTROY',
            defaultValue: false,
            description: 'Check this only when you want to destroy the AWS infrastructure'
        )
    }

    environment {
        AWS_REGION = 'ap-south-1'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir('terraform') {
                    sh 'terraform fmt -check'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression {
                    return params.DESTROY == false
                }
            }

            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    return params.DESTROY == false
                }
            }

            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    return params.DESTROY == true
                }
            }

            steps {
                input(
                    message: 'Do you really want to destroy ALL AWS resources?',
                    ok: 'YES, DESTROY'
                )

                dir('terraform') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'AWS MONITORING & AUTO-HEALING PIPELINE COMPLETED SUCCESSFULLY'
        }

        failure {
            echo 'PIPELINE FAILED - CHECK JENKINS CONSOLE LOGS'
        }

        aborted {
            echo 'PIPELINE ABORTED'
        }
    }
}