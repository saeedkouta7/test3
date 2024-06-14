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

        stage('Install Python Packages on Remote Host') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ivolve_private_key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                    script {
                        // Install required Python packages on the remote host
                        sh '''
                        ssh -i $SSH_PRIVATE_KEY -o StrictHostKeyChecking=no ubuntu@${PUBLIC_IP} << EOF
                            sudo apt-get update
                            sudo apt-get install -y python3-pip
                            pip3 install ansible
                        EOF
                        '''
                    }
                }
            }
        }
        
        stage('Run Ansible Playbook') {
            steps {
                dir("${ANSIBLE_DIR}") {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ivolve_private_key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                        script {
                            // Ensure the key has the correct permissions
                            sh 'chmod 400 $SSH_PRIVATE_KEY'
                            // Run the Ansible playbook
                            sh '''
                            ansible-playbook -i ${INVENTORY_FILE} playbook.yml --private-key $SSH_PRIVATE_KEY
                            '''
                        }
                    }     
                }
            }
        }
    }
}
