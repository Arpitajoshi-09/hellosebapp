Complete CICD pipeline  with Jenkins kubernetes and monitoring tools(prometeus and garafana):

 +-----------------+       +-----------------+       +-----------------+
  |                 |       |                 |       |                 |
  |   Source Code   |       |   Version       |       |    Production   |
  |   Repository    |       |   Control       |       |    Environment  |
  |                 |       |   System        |       |                 |
  +-----------------+       +-----------------+       +-----------------+
         |                         |                         |
         |                         |                         |
         |                         |                         |
         v                         v                         v
  +-----------------+       +-----------------+       +-----------------+
  |                 |       |                 |       |                 |
  |   Continuous    |       |   Automated     |       |   Deployed      |
  |   Integration   +------►|   Builds &      +------►|   Application   |
  |   Server (e.g., |       |   Tests         |       |   in Kubernetes |
  |   Jenkins)      |       |                 |       |   or other      |
  |                 |       |                 |       |   Platforms     |
  +-----------------+       +-----------------+       +-----------------+
         |                         |                         |
         |                         |                         |
         |                         |                         |
         v                         v                         v
  +-----------------+       +-----------------+       +-----------------+
  |                 |       |                 |       |                 |
  |   Artifact      |       |   Automated     |       |   Production-   |
  |   Repository    |◄------|   Deployment    |◄------|   Ready         |
  |   (e.g., Nexus, |       |   to Staging/   |       |   Application   |
  |   Artifactory)  |       |   Production    |       |                 |
  |                 |       |   Environment   |       |                 |
  +-----------------+       +-----------------+       +-----------------+

Steps to implement java hello world program:



Create EC2 Instances
NOTE: If you are lazy, you can use a pre-configured AMI with Jenkins, Git and Docker. To do so, use jenkins-docker 1524155485 (ami-fc47eb83) in step 2 and jump directly to Run the Jenkins Setup Wizard after launching the instance.
1.	In the EC2 console click Launch Instance.
2.	Select an Amazon Linux AMI.
3.	Leave t2.micro selected and click Next: Configure Instance Details.
4.	Under Network, choose any VPC with a public subnet. The default VPC will work fine here, too.
5.	Under Subnet, choose any public subnet.
6.	Under Auto-assign Public IP choose Enabled.
7.	Under IAM role choose the Jenkins role you created before.
8.	Click Next: Add Storage.
9.	Click Next: Add Tags.
10.	Create a tag with the key "Name" and the value "Jenkins" and click Next: Configure Security Group.
11.	Name the security group "Jenkins" and allow SSH access as well as access to TCP port 8080 from your WAN IP address.
12.	Click Review and Launch.
13.	Click Launch.
14.	Choose an existing SSH key or create a new one, then click Launch Instances.
Install Jenkins
Note: If you've deployed Jenkins from a pre-configured AMI, go directly to Run the Jenkins Setup Wizard.
1.	SSH into the instance you created in the previous step.
2.	Run the following commands to install Jenkins:
3.	sudo yum remove -y java
4.	 sudo yum install -y java-1.8.0-openjdk
5.	 sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
6.	 sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
7.	 sudo yum install -y jenkins
8.	Run sudo service jenkins start to start the Jenkins service.
Install Git and Docker on the Jenkins Instance
1.	SSH into the Jenkins instance if you are not already there.
2.	Run the following commands on the Jenkins instance:
3.	 sudo yum install -y git docker
4.	 sudo service docker start
5.	 # Allow Jenkins to talk to the Docker daemon
6.	 sudo usermod -aG docker jenkins
7.	 sudo service jenkins restart
Run the Jenkins Setup Wizard
1.	Browse http://<instance_ip>:8080.
2.	Under Administrator password enter the output of sudo cat /var/lib/jenkins/secrets/initialAdminPassword on the Jenkins instance.
3.	Click Continue.
4.	Click Install suggested plugins and let the installation finish.
5.	Click Continue as admin.
6.	Click Start using Jenkins.
 
 
 
Install More instances for Build server and kubernetes server on AWS:
 

# A Java/Maven/JUnit HelloWorld example

A „Hello World!” sample written in Java using Maven for the build, that showcases a few very simple tests.

This example demonstrates:

* A simple Java 8 application with tests
* Unit tests written with [JUnit 5](https://junit.org/junit5/)
* Integration tests written with [JUnit 5](https://junit.org/junit5/)
* Code coverage reports via [JaCoCo](https://www.jacoco.org/jacoco/)
* A Maven build that puts it all together

## Running the tests

* To run the unit tests, call `mvn test`
* To run the integration tests as well, call `mvn verify`
* Code coverage reports are generated when `mvn verify` (or a full `mvn clean install`) is called.
  Point a browser at the output in `target/site/jacoco-both/index.html` to see the report.

## Conventions

This example follows the following basic conventions:

| | unit test | integration test |
| --- | --- | --- |
| **resides in:** | `src/test/java/*Test.java` | `src/test/java/*IT.java` |
| **executes in Maven phase:** | test | verify |


Mavenproject architecture to be followed:
- HelloWorldApp
  |- src
     |- Main.java
     |- HelloWorld.java
  |- test
     |- TestHelloWorld.java
  |- Dockerfile
|- JenkinsFile.

File architecture in git hub repository:
 
 
Creating the Pipeline
We will now create the Jenkins pipeline. Perform the following steps on the Jenkins UI:
1.	Click New Item to create a new Jenkins job.
2.	Under Enter an item name type "sample-pipeline".
3.	Choose Pipeline as the job type and click OK.
4.	Under Pipeline -> Definition choose Pipeline script from SCM.
5.	Under SCM choose Git.
6.	Under Repository URL paste the HTTPS URL of your (forked) repository.
NOTE: It is generally recommended to use Git over SSH rather than HTTPS, especially in automated processes. However, to simplify things and since the repository is public, we can simply use the HTTPS URL instead of dealing with SSH keys.
7.	Leave the rest at the default and click Save.
You should now have a pipeline configured. When executing the pipeline, Jenkins will clone the Git repository, look for a file named Jenkinsfile at its root and execute the instructions in it.

Add CICDstages with declarative pipeline:
 
SCM Checkout Stage ==> Build ==> Create the artifacts ==> Save/Archive the Artifacts ==> Deploy to Target Envi. 
pipeline {
    agent any

	environment {	
		DOCKERHUB_CREDENTIALS=credentials('dockercrd')
	} 
	
    stages {
        stage('scm checkout') {
            steps {
                echo 'Perform SCM Checkout'
                git 'https://github.com/Arpitajoshi-09/aquilaCMS.git’
                
            }
        }
        stage('build') {
            steps {
                sh  'npm install' 
            }

        }
        }
       stage("Docker build"){
            steps {
				sh 'docker version'
			sh "docker build -t tomcat_image1  ."
				sh 'docker image list'
				sh "docker tag   tomcat_image1 arpitajoshidevops07/loksai-eta-app1:${BUILD_NUMBER}"
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
				sh "docker push arpitajoshidevops07/loksai-eta-app1:${BUILD_NUMBER}"
			}
		}

        stage('Deploy to Kubernetes Server') {
            steps {
                // Run Maven on a Unix agent.
				script {
					sshPublisher(publishers: [sshPublisherDesc(configName: 'kubenetes_Server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '.', remoteDirectorySDF: false, removePrefix: 'target/', sourceFiles: 'target/hello.java')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
				}
            }
		}
 
 
Check the Docker hub for image pulled.
For monitoring use prometeus and fragana connect it with kubernetes server:
Login to prometeus and grafana by port numbers (prometeus :9090 and grafana :3000) after the requied ip adresss
 
 
 
 
Prometeus and grafana dashboard:
