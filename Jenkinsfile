pipeline {
    agent { 
label 'java_salve2'
 }
environment {	
		DOCKERHUB_CREDENTIALS=credentials('dockercrd')
	} 
    
     stages {
        stage('SCM-Checkout') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/Arpitajoshi-09/newphpwebapp.git'

            }
			}
         
        
       stage("Docker build"){
            steps {
				sh 'docker version'
			sh "docker build -t helloworld ."
				sh 'docker image list'
				sh "docker tag helloworld arpitajoshidevops07/newhelloworld:${BUILD_NUMBER}"
            }
        }
		stage('Login2DockerHub') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
        stage('Approve - push Image to dockerhub'){
            steps{
                
                //----------------send an approval prompt-------------
                script {
                   env.APPROVED_DEPLOY = input message: 'User input required Choose "yes" | "Abort"'
                       }
                //-----------------end approval prompt------------
            }
        }
        stage('Push2DockerHub') {

			steps {
				sh "docker push arpitajoshidevops07/newhelloworld:${BUILD_NUMBER}"
			}
		}
        stage('Deploy to kubernetesServer') {
            steps {
                // Run Maven on a Unix agent.
				script {
				    sshPublisher(publishers: [sshPublisherDesc(configName: 'kubernetes_Server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: 'target/', sourceFiles: 'target/hello.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
				}
				
            }
			}
    }