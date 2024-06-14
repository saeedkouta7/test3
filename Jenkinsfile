pipeline {
    agent any

    environment {
        TERRAFORM_DIR = 'terraform' // Path to the Terraform directory
        BACKEND_DIR = 'terraform/,odules/backend' // Path to the backend Terraform directory
        ANSIBLE_DIR = 'ansible-roles' // Path to the Ansible directory
        INVENTORY_FILE = 'inventory' // Path to the Ansible inventory file
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID') // Jenkins credentials for AWS Access Key
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') // Jenkins credentials for AWS Secret Key
        AWS_REGION            = 'us-east-1'
    }

    stages {
        stage('Terraform Init') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Backend Terraform Init') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Backend Terraform Apply') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get Public IP') {
            steps {
                script {
                    env.PUBLIC_IP = sh(script: "cd ${env.TERRAFORM_DIR} && terraform output -raw public_ip", returnStdout: true).trim()
                    echo "Public IP: ${env.PUBLIC_IP}"
                }
            }
        }

        stage('Update Ansible Inventory') {
            steps {
                script {
                    def inventoryContent = "[ec2]\n${env.PUBLIC_IP} ansible_user=ubuntu\n"
                    writeFile file: "${env.ANSIBLE_DIR}/${env.INVENTORY_FILE}", text: inventoryContent
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir("${env.ANSIBLE_DIR}") {
                    sh 'ansible-playbook -i inventory playbook.yml'
                }
            }
        }
    }
}
