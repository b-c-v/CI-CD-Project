# v1.0 CI/CD pipeline

**_Description:_**

CI/CD project Git==>GitHub==>Jenkins==>Maven==>Ansible==>Tomcat&Docker==>DockerHub==>Kubernetes

When making changes to the GitHub repository with the simple Java application - Jenkins starts the process of building and testing it with Maven and transfers to Ansible server. Ansible starts the process of building the Docker image and copying it to DockerHub. After that, this image is uploaded from DockerHub to AWS EKS running.

![](images/CI-CD-k8s.jpg)

---

## 1. Docker server

### 1.1 launch AmazonLinux EC2 Instance and create a new Security group (allowing SSH (22) and HTTP (8080)).

### 1.2 connect via SSH to instance, download to it and run a script [2.1_install_docker.sh](2_Docker/2.1_install_docker.sh) and it will install Docker and change hostname.

### 1.3 create a user under which Jenkins will connect to the server. Download to it and run a script [2.2_create_user_docker.sh](2_Docker/2.2_create_user_docker.sh)

### 1.4 create a user under which Ansible will connect to the server. Download to it and run a script [2.3_create_user_ansible.sh](2_Docker/2.3_create_user_ansible.sh)

---

## 2. K8s server

### 2.1 create IAM role for AWS Service (name k8s-role) ==> EC2 add Permissions policies:

- AmazonEC2FullAccess
- AWSCloudFormationFullAccess
- IAMFullAccess

### 2.2 create EC2 instance. Name is K8s. Same security group with Jenkins, Ansible, Docker servers. Attach create role: Advanced detail ==> IAM instance profile ==> select created before role

### 2.3 login as root and create password:

```
sudo -i
passwd root
```

### 2.4 download and run [script](5_Kubernetes/5.1_install_packeges_K8s.sh) for installation packages

### 2.5 download and run [SSH modify script](5_Kubernetes/5.2_ssh_modify.sh)

---

## 3. Ansible server

### 3.1 launch a second AmazonLinux EC2 Instance and connect to the same security group as the previous one.

### 3.2 connect via SSH to instance, download to it and run a script [3.1_install_ansible_amazon.sh](3_Ansible/3.1_install_ansible_amazon.sh) and it will install Ansible, Docker and change hostname.

### 3.3 create a user under which Ansible will connect to the Docker-server and in the working directory of the project _(/opt/docker/)_. Run script [3.2_create_user_ansible.sh](3_Ansible/3.2_create_user_ansible.sh)

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
ssh-copy-id *root@PRIVATE_IP_K8s-server*

```

### 3.5 login to DockerHub:

```bash
docker login
```

### 3.6 copy files to directory _(/opt/docker/)_:

- [Dockerfile](3_Ansible/Dockerfile)
- [3.3_playbook_push_image.yml](3_Ansible/3.3_playbook_push_image.yml)
- [hosts.ini](3_Ansible/hosts.ini) and add information about private IP of K8s and Ansible servers
- [kube_deploy.yml](5_Kubernetes/kube_deploy.yml)

---

## 4. K8s server

### 4. copy files [cicd-deployment.yml](5_Kubernetes/cicd-deployment.yml) and [cicd-service.yml](5_Kubernetes/cicd-service.yml) to folder **_/root/_**

### 4.1 create cluster (it takes about 20 minutes). In AWS CloudFromation can see crating new Stack

- Run command

```
eksctl create cluster --name k8s \
--region us-east-1 \
--node-type t2.small \
--zones us-east-1a,us-east-1b
```

## 3. Jenkins server

### 3.1 Launch a third AmazonLinux EC2 Instance and connect to the same security group as the previous two.

### 3.2 connect via SSH to instance, download to it and run a script [1.1_install_packages_AmazonLinux.sh](1_Jenkins/1.1_install_packages_AmazonLinux.sh)

It will install:

- Jenkins and Java
- GIT
- Maven
- rename hostname to "jenkins"

### 3.3 In Jenkins settings create token (Manage Jenkins==>Manage Users==>_your_user_name_==>Configure==>API Token==>Add new token) and run script [1.2_install_jenkins_plugins.sh](1_Jenkins/1.2_install_jenkins_plugins.sh)

It will install plugins:

- GIT
- Maven
- Deploy (pack Java war file to docker container)
- GitHub (trigger to run build project after push changes to git repo)
- Publish over SSH (for connection to Docker-server and Ansible-server)

### 3.4 Create trigger to automatically start a job in Jenkins, when some changes are made to the GitHub repository

- in settings GitHub repository with the project, specify the address of Jenkins-server and type of events to trigger this webhook _(http://ip_jenkins_server:8080/github-webhook/)_
  ![](images/webhook_git.jpg)

### 3.5 Manually configure Jenkins

- Manage Jenkins ==> Configure System ==> Publish over SSH add IP address of Ansible-server, username and created user password.

  ![](images/ansible_ssh.jpg)

  > A better solution is to use an SSH key

- Manage Jenkins ==> Global Tool Configuration ==> configure GIT, JDK and Maven
  ![](images/glob_conf_1.jpg)
  ![](images/glob_conf_2.jpg)
  ![](images/glob_conf_3.jpg)

### 3.6 Create new Maven project

![](images/Ansible_CI-CD.jpg)

### 3.7 Create new Freestyle project

![](images/k8s-deploy.jpg)

```
ansible-playbook -i /opt/docker/hosts.ini /opt/docker/kube_deploy.yml
```

- and by address http://LOAD_BALANCER_DNS:8080/webapp/ will see registration form.

![](images/registration_form.jpg)
