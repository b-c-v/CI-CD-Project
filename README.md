# CI/CD pipeline

## 1. Continuous integration (CI)

1. **_Install Jenkins:_**

- On local machine (Ubuntu) and run script 1_Jenkins/1.1_install_packages.sh
- If you want to use webhook from GitHub to Jenkins for CI process - it's necessary use AmazonLinux EC2 Instance with public IP. Run script 1_Jenkins/1.1.1_install_packages_AmazonLinux on EC2.

  They will:

  - install Jenkins
  - install GIT
  - install Maven
  - install Terraform
  - install AWS (only on Ubuntu)
  - clone all configuration files from this repo to folder Download

2. **_Install Jenkins plugins:_**

- in Jenkins settings create token (Manage Jenkins==>Manage Users==>user_name==>Configure==>API Token==>Add new token) and run script 1_Jenkins/1.2_install_jenkins_plugins.sh
  It will install plugins:

  - GIT
  - Maven
  - Deploy (pack Java war file to docker container)
  - GitHub (trigger to run build project after push changes to git repo)
  - Publish over SSH (for connection to Docker-server and Ansible-server)

3. **_Create AmazonLinux EC2 instance with Tomcat:_**

- "terraform init" and "terraform apply" project in folder 2_Tomcat_terraform. During instance initialization will:

  - change hostname
  - install Java
  - install Tomcat

- Or on AmazonLinux run script 2_Tomcat_terraform/modules/webserver/installTomcat.sh

4. **_Trigger to automatically start a job in Jenkins when some changes are made to the github repository (Jenkins-server static external IP is required)_**

- in setting up the github repository with the project, specify the address of Jenkins-server and type of events to trigger this webhook

- in setting of Jenkins project specify the address of GitHub repo and put mark near GitHub hook trigger
  ![](images/docker_project_2.jpg)
  ![](images/docker_project_4.jpg)

5. **_Manually configure Tomcat:_**

- comment in files /opt/tomcat/webapps/host-manager/META-INF/context.xml and /opt/tomcat/webapps/manager/META-INF/context.xml line <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
- add users to file /opt/tomcat/conf/tomcat-users.xml
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="admin" password="your_password" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
  <user username="deployer" password="your_password" roles="manager-script"/>
  <user username="tomcat" password="your_password" roles="manager-gui"/>

6. **_Manually configure Jenkins:_**

- Manage Jenkins ==> Global Tool Configuration configure GIT, JDK and Maven
  ![](images/glob_conf_1.jpg)
  ![](images/glob_conf_2.jpg)
  ![](images/glob_conf_3.jpg)
- Add credentials to connect with Tomcat server
  ![](images/jenk_cred_1.jpg)
- Create new Item (Maven project)
  ![](images/mvn_project_1.jpg)
  ![](images/mvn_project_2.jpg)
  ![](images/mvn_project_3.jpg)
  ![](images/mvn_project_4.jpg)
  ![](images/mvn_project_5.jpg)
  ![](images/mvn_project_6.jpg)
- or from file 1_Jenkins/CICD_Tomcat.xml export settings of this project (command: java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token -webSocket create-job Tomcat_CI_CD < CICD_Tomcat.xml)

### CI project is ready (Git==>GitHub==>Jenkins==>Maven)

![](images/CI.jpg)

---

## 2. Continuous delivery/deployment (CD) Docker

1. **_Install Docker:_**

- create EC2 instance in some security group with Jenkins
- run script 3_Docker/3.1_install_docker.sh
- create a user under which Jenkins will connect to the server. Run script 3_Docker/3.3_create_user_docker.sh

2. **_Copy file 3_Docker/Dockerfile to folder /opt/docker_**

3. **_Manually configure Jenkins:_**

- Manage Jenkins ==> Configure System ==> Publish over SSH add IP address of Docker-server, username and password created user.
  ![](images/docker_jenk_1.jpg)
  ![](images/docker_jenk_2.jpg)

  \*A better solution is to use an SSH key

4. **_Create new Item (Maven project):_**
   ![](images/docker_project_1.jpg)
   ![](images/docker_project_2.jpg)
   ![](images/docker_project_3.jpg)
   ![](images/docker_project_4.jpg)
   ![](images/docker_project_5.jpg)
   ![](images/docker_project_6.jpg)

   - script to section "Exec command" is in file 3_Docker/3.4_script_to_project.txt

- or from file 1_Jenkins/CICD_Docker.xml export settings of this project (command: java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token -webSocket create-job Docker_CI_CD < CICD_Docker.xml)

### CI/CD project is ready (Git==>GitHub==>Jenkins==>Maven==>Tomcat&Docker)

![](images/CI-CD-docker.jpg)

## 3. Continuous delivery/deployment (CD) Ansible

1. **_Install Ansible:_**

- create EC2 instance in some security group with Jenkins-server and Docker-server
- run script 4_Ansible/4.1_install_ansible_amazon.sh and it will install Ansible and Docker.
- create a user under which Ansible will connect to the Docker-server. Run script 3_Docker/3.3_create_user_docker.sh

2. **_Copy files to folder /opt/docker files:_**

- 4_Ansible/Dockerfile to
- 4_Ansible/4.3_playbook_push_image.yml
- 4_Ansible/4.4_playbook_run_container.yml

3. **_Manually configure Jenkins:_**

- Manage Jenkins ==> Configure System ==> Publish over SSH add IP address of Ansible-server, username and password created user.
  ![](images/ansible_ssh.jpg)
  \*A better solution is to use an SSH key

4. **_Create new Item (Maven project):_**
   ![](images/ansible_project1.jpg)
   ![](images/docker_project_2.jpg)
   ![](images/docker_project_3.jpg)
   ![](images/docker_project_4.jpg)
   ![](images/docker_project_5.jpg)
   ![](images/ansible_project6.jpg)

- script to section "Exec command" is in file 3_Docker/3.4_script_to_project.txt

- or from file 1_Jenkins/CICD_Ansible.xml export settings of this project (command: java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token -webSocket create-job Ansible_CI_CD < CICD_Ansible.xml)

### CI/CD project is ready (Git==>GitHub==>Jenkins==>Maven==>Ansible==>Tomcat&Docker==>DockerHub==>Web Server)

![](images/CI-CD-ansible.jpg)
