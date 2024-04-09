node ("jdk17")
{
    err =  null
    try {
        checkout('*/master', 'https://github.com/juanssanchezv/jenkins-test.git')
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: "AWS-Credentials-Hardcoded",
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
            // AWS Code
            terraformInit('./init-tfvars/dev.tfvars')

            terraformPlan('./apply-tfvars/dev.tfvars')
            
            terraformApply()
         
        }

    }
    catch(exception){
        err =  exception
        currentBuild.result = 'FAILURE'
    }
    finally{
        cleanWs()
        if(err){
            throw err
        }
    }
}

def checkout(branch, repoUrl, credentials=""){
    configs = [
        url: repoUrl
    ]
    if(credentials) {
        config['credentialsId'] = credentials
    }
    stage ("Checkout"){
        checkout scmGit(branches: [[name: branch]], extensions: [], userRemoteConfigs: [configs])
    }
}

def terraformInit (configFilePath="") {
    stage ("Terraform init") {
        if (configFilePath){ 
            sh "terraform init -backend-config=${configFilePath}"
        }
        else {
            sh "terraform init"
        }
    }
}

def terraformPlan (configFilePath="") {
    stage ("Terraform plan") {
        if (configFilePath){ 
            sh "terraform plan -var-file=${configFilePath} -out=tfPlan"
        }
        else {
            sh "terraform plan -out=tfPlan"
        }
    }
}

def terraformApply (configFilePath="") {
    stage ("Terraform apply") {
        if (configFilePath){ 
            sh "terraform apply tfPlan"
        }
        else {
            sh "terraform apply tfPlan"
        }
    }
}