# v1.1 CI/CD pipeline

**_Description:_**

CI/CD project Terraform ==> Git==>GitHub==>Jenkins==>Maven==>Ansible==>Tomcat&Docker==>DockerHub==>Web Server

When making changes to the GitHub repository with the simple Java application - Jenkins starts the process of building and testing it with Maven and transfers to Ansible server. Ansible starts the process of building the Docker image and copying it to DockerHub. After that, this image is uploaded from DockerHub to the Docker server and running.

![](images/CI-CD-terraform.jpg)

---

## 1. Preparing the environment for project implementation:

### 1.1 in folder /tmp/ on your local computer (Ubuntu), download folder [environment](environment)

### 1.2 run script [1_install_terraform_Ubuntu.sh](4_Terraform/1_install_terraform_Ubuntu.sh) at the end - enter credentials to connect to AWS

<!-- надо установить ансибл

sudo apt update
sudo apt install software-properties-common  -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible  -y
ansible --version -->

<!-- надо установить Jenkins
sudo apt update
sudo apt install -y curl
sudo apt install -y openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install jenkins
sudo systemctl enable jenkins # Enable the Jenkins service to start at boot
sudo systemctl start jenkins # Start Jenkins as a service
sudo cat /var/lib/jenkins/secrets/initialAdminPassword -->

<!-- install git
sudo apt install git -y -->

<!-- in Jenkins:
1) Install plugins Terraform, Pipeline, Git, GitHub, Ansible, AnsiColor, CloudBees AWS Credentials
2) Jenkins ==> Manage Jenkins ==> Global Tool Configuration add information where it installed:
 - Terraform. Find where it installed (/usr/bin/):
```
whereis terraform
```
- Ansible. Find where it installed (/usr/bin/)
```
which ansible
```
3) Create Jenkins job - pipeline -->

### 1.3 at the root of the project, create a file "terraform.tfvars" and enter the values of variables. For example:

```bash
main_vpc_cidr_block    = "10.0.0.0/16"
main_subnet_cidr_block = "10.0.10.0/24"
main_avail_zone        = "eu-central-1a"
main_env_prefix        = "CICD"
main_my_ip             = "0.0.0.0/0"
main_instance_type     = "t2.micro"
main_my_publick_key_location = "~/.ssh/id_rsa.pub"
main_image_name = "amzn2-ami-kernel-*-x86_64-gp2"
```

### 1.4 create ssh key with name aws in folder ~/.ssh/

```
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -f aws
```

### 1.5 start the porcess of creating EC2 instances

```bash
terraform init
terraform apply
```

## 2. Docker server

### 2.1 launch AmazonLinux EC2 Instance and create a new Security group (allowing SSH and HTTP).

### 2.2 connect via SSH to instance, download to it and run a script [2.1_install_docker.sh](2_Docker/2.1_install_docker.sh) and it will install Docker and change hostname.

### 2.3 create a user under which Jenkins will connect to the server. Download to it and run a script [2.2_create_user_docker.sh](2_Docker/2.2_create_user_docker.sh)

### 2.4 create a user under which Ansible will connect to the server. Download to it and run a script [2.3_create_user_ansible.sh](2_Docker/2.3_create_user_ansible.sh)

---

## 3. Ansible server

### 3.1 launch a second AmazonLinux EC2 Instance and connect to the same security group as the previous one.

### 3.2 connect via SSH to instance, download to it and run a script [3.1_install_ansible_amazon.sh](3_Ansible/3.1_install_ansible_amazon.sh) and it will install Ansible, Docker and change hostname.

### 3.3 create a user under which Ansible will connect to the Docker-server and the working directory of the project _(/opt/docker/)_. Run script [3.2_create_user_ansible.sh](3_Ansible/3.2_create_user_ansible.sh)

### 3.4 change SSH-keys with servers:

- generate SSH-key for created user:

```bash
su *your_user_name*
ssh-keygen
```

- exchange ssh-key

```bash
ssh-copy-id *ip_localhost* #it's necessary to exchange the SSH-key with the local server on behalf of the created user
ssh-copy-id *ip_docker_server*
```

### 3.5 Login to DockerHub:

```bash
docker login
```

### 3.6 Copy files to directory _(/opt/docker/)_:

- [Dockerfile](3_Ansible/Dockerfile)
- [3.3_playbook_push_image.yml](3_Ansible/3.3_playbook_push_image.yml)
- [3.4_playbook_run_container.yml](3_Ansible/3.4_playbook_run_container.yml)

---

## 4. Jenkins server

### 4.1 Launch a third AmazonLinux EC2 Instance and connect to the same security group as the previous two.

### 4.2 connect via SSH to instance, download to it and run a script [1.1_install_packages_AmazonLinux.sh](1_Jenkins\1.1_install_packages_AmazonLinux.sh)

It will install:

- Jenkins and Java
- GIT
- Maven
- rename hostname to "jenkins"

### 4.3 In Jenkins settings create token (Manage Jenkins==>Manage Users==>_your_user_name_==>Configure==>API Token==>Add new token) and run script [1.2_install_jenkins_plugins.sh](1_Jenkins/1.2_install_jenkins_plugins.sh)

It will install plugins:

- GIT
- Maven
- Deploy (pack Java war file to docker container)
- GitHub (trigger to run build project after push changes to git repo)
- Publish over SSH (for connection to Docker-server and Ansible-server)

### 4.4 Create trigger to automatically start a job in Jenkins, when some changes are made to the GitHub repository

- in settings GitHub repository with the project, specify the address of Jenkins-server and type of events to trigger this webhook _(http://ip_jenkins_server:8080/github-webhook/)_
  ![](images\webhook_git.jpg)

### 4.5 Manually configure Jenkins

- Manage Jenkins ==> Configure System ==> Publish over SSH add IP address of Ansible-server, username and created user password.

  ![](images/ansible_ssh.jpg)

  > A better solution is to use an SSH key

- Manage Jenkins ==> Global Tool Configuration ==> configure GIT, JDK and Maven
  ![](images/glob_conf_1.jpg)
  ![](images/glob_conf_2.jpg)
  ![](images/glob_conf_3.jpg)

### 4.6 Create new Item (Maven project)

![](images/project_1.jpg)
![](images/project_2.jpg)
![](images/project_3.jpg)
![](images/project_4.jpg)
![](images/project_5.jpg)
![](images/project_6.jpg)
![](images/project_7.jpg)

> script to section "Exec command" is in file [3.5_script_to_project.txt](3_Ansible\3.5_script_to_project.txt)

- or from file [CICD_Ansible.xml](1_Jenkins/CICD_Ansible.xml) export settings of this project:

```bash
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth *your_user:your_token* -webSocket create-job Ansible_CI_CD < CICD_Ansible.xml)
```

---

## If you type in a link `http://ip_docker_server/webapp` in a browser, you can see

![](images/registration_form.jpg)
