
@Library('cloudcampSharedLibrary') _

config = [
    branch: 'master',
    repoUrl: 'https://github.com/juanssanchezv/jenkins-test.git',
    filePathInit: './init-tfvars/dev.tfvars',
    filePathApply: './apply-tfvars/dev.tfvars'
]

node ("jdk17")
{
    err =  null
    try {
        def utils = new la.cloudcamp.Utils()
        utils.checkoutFromRepo('*/master', 'https://github.com/juanssanchezv/jenkins-test.git')
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: "AWS-Credentials-Hardcoded",
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
            // AWS Code
            def tfUtils = new TerraformUtils(this)
            stage ('Terraform Init') {
                tfUtils.tfInit(config)
            }

            terraformUtils.terraformPlan(config)
            
            terraformUtils.terraformApply()
         
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