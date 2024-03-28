node ("jdk17")
{
    stage ("Checkout"){
        checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/juanssanchezv/jenkins-test.git']])
    }
    stage ("Terraform init") {
        sh "terraform init -backend-config=./init-tfvars/dev.tfvars"
    }
    stage ("Terraform plan") {
        sh "terraform plan -var-file=./apply-tfvars/dev.tfvars"
    }
}
