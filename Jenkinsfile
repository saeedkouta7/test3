pipeline {
    agent any

    environment {
        TERRAFORM_DIR = 'terraform'
        BACKEND_DIR = 'terraform/modules/backend'
        ANSIBLE_DIR = 'ansible-roles'
        INVENTORY_FILE = 'inventory'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Set Private Key Permissions') {
            steps {
                script {
                    // Retrieve the SSH private key credential
                    def sshPrivateKey = credentials('ivolve_private_key')

                    // Get the path to the SSH private key file
                    def sshPrivateKeyPath = sshPrivateKey.filePath

                    // Set permissions on the private key
                    sh "chmod 400 ${sshPrivateKeyPath}"
                }
            }
        }
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

        stage('Delay Before Ansible Playbook') {
            steps {
                script {
                    echo "Waiting for 1 minute before proceeding..."
                    sleep time: 60, unit: 'SECONDS'
                    echo "Proceeding to run Ansible playbook..."
                }
            }
        }
        
        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    // Use 'withCredentials' to inject the SSH private key into the environment
                    withCredentials([sshUserPrivateKey(credentialsId: 'ivolve_private_key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                        script {
                            echo "Running Ansible playbook with inventory file: ../${INVENTORY_FILE}"
                        }
                        sh '''
                        ansible-playbook -i ../${INVENTORY_FILE} playbook.yml
                        '''
                    }     
                }
            }
        }
    }
}
