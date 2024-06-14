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

        stage('Setup Python Virtual Environment on Remote Host') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ivolve_private_key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                    script {
                        // Create a virtual environment and install Ansible on the remote host
                        sh '''
                        ssh -i $SSH_PRIVATE_KEY -o StrictHostKeyChecking=no ubuntu@${PUBLIC_IP} << 'EOF'
                            sudo apt-get update
                            sudo apt-get install -y python3-venv
                            python3 -m venv ansible_venv
                            source ansible_venv/bin/activate
                            pip install ansible
                            deactivate
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
                            // Run the Ansible playbook within the virtual environment
                            sh '''
                            ssh -i $SSH_PRIVATE_KEY -o StrictHostKeyChecking=no ubuntu@${PUBLIC_IP} << 'EOF'
                                source ansible_venv/bin/activate
                                ansible-playbook -i ${ANSIBLE_DIR}/${INVENTORY_FILE} ${ANSIBLE_DIR}/playbook.yml
                                deactivate
                            EOF
                            '''
                        }
                    }
                }
            }
        }
    }
}
