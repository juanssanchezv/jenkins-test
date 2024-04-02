node ("jdk17")
{
    stage ("Checkout"){
        checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/juanssanchezv/jenkins-test.git']])
    }
        withCredentials([[
    $class: 'AmazonWebServicesCredentialsBinding',
    credentialsId: "AWS-Credentials-Hardcoded",
    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
    ]]) {
        // AWS Code
        stage ("Terraform init") {
            sh "terraform init -backend-config=./init-tfvars/dev.tfvars"
        }
        stage ("Terraform plan") {
            sh "terraform plan -var-file=./apply-tfvars/dev.tfvars"
        }
        stage ("Show ENV"){
            sh "env | sort"
        }
    }

    stage ("Dockerbuild") {
        sh "cd .. && docker build ."
    }
}
