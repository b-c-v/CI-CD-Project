**_CI/CD pipeline:_**

- [x] **CI**

1. Install Jenkins:
   1.1 On local machine (Ubuntu) and run script 1_Jenkins\/1.1_install_packages.sh
   1.2 If you want to use webhook from GitHub to Jenkins it's necessary use EC2 Instance with public IP. Run script \1_Jenkins\/1.1.1_install_packages_AmazonLinux on EC2.
   They will:

- install Jenkins
- install GIT
- install Maven
- install Terraform
- install AWS (only on Ubuntu)
- clone all configuration files from this repo to folder Download

2. Install plugins Jenkins: in Jenkins settings create token (Manage Jenkins==>Manage Users==>user_name==>Configure==>API Token==>Add new token) and run script 1_Jenkins\/1.2_install_jenkins_plugins.sh It will install plugins:

- GIT
- Maven
- Deploy (pack Java war file to docker container)
- GitHub (trigger to run build project after push changes to git repo)

3. Create EC2 instance with Tomcat:
   3.1 terraform init and terraform apply project in folder 2_Tomcat_terraform. During instance initialization will:

- change hostname
- install Java
- install Tomcat
  3.2 Or on EC2Instance run script 2_Tomcat_terraform\/modules\/webserver\/installTomcat.sh

4. Manually configure Tomcat:

- comment in files /opt/tomcat/webapps/host-manager/META-INF/context.xml and /opt/tomcat/webapps/manager/META-INF/context.xml line <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
- add users to file /opt/tomcat/conf/tomcat-users.xml
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="admin" password="your_password" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
  <user username="deployer" password="your_password" roles="manager-script"/>
  <user username="tomcat" password="your_password" roles="manager-gui"/>

5. Manually configure Jenkins:

- Manage Jenkins ==> Global Tool Configuration configure GIT, JDK and Maven sections
  **add image**
- Add credentials to connect with Tomcat server
- Create new Item (Maven project)
  **add image**
  **_CI project Git==>GitHub==>Jenkins==>Tomcat is ready_**

6. Install Docker:
   6.1 In AmazonLinux run script 3_Docker\/install_docker.sh
   6.2 copy 3_Docker\/Dockerfile and run command "docker image build -t cicd ."

- [ ] **CD**
