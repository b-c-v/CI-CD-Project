**_CI/CD pipeline:_**

- [x] **CI**

1. Install Jenkins: on local machine (Ubuntu) run script 1_Jenkins\/1.1_install_packages.sh It will:

- install Jenkins
- install GIT
- install Maven
- install Terraform
- install AWS
- clone all configuration files from this repo to folder Download

2. Install plugins Jenkins: in Jenkins settings create token (Manage Jenkins==>Manage Users==>user_name==>Configure==>API Token==>Add new token) and run script 1_Jenkins\/1.2_install_jenkins_plugins.sh It will install plugins:

- GIT
- Maven
- Deploy (pack Java war file to docker container)

3. Create EC2 instance with Tomcat: terraform init and terraform apply project in folder 2_Tomcat_terraform. During instance initialization will:

- change hostname
- install Java
- install Tomcat

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
- Create new Item (Maven project)

- [ ] **CD**
