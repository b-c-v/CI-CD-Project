# v1.2 CI/CD project

**_Description:_**

- Preparing the environment with Jenkins==>Terraform==>Ansible
- CI/CD pipeline with Git==>GitHub==>Jenkins==>Maven==>Ansible==>Tomcat&Docker==>DockerHub==>Web Server

To prepare deployment environment, use Jenkins, Terraform, and Ansible, installing them and configuring Jenkins project accordingly.
After committing changes to GitHub repository, Jenkins will build and test the application with Maven before transferring it to the Ansible server. There, Ansible will build a Docker image and send it to DockerHub before uploading it to the Docker server and launching it.

![](images/CI-CD-terraform.jpg)

---

## 1. Preparing the environment for project implementation:

### 1.1 On your local computer (Ubuntu), download and run a script [1_install_packages_Ubuntu.sh](1_environment/1_install_packages_Ubuntu.sh)

```
chmod +x 1_install_packages_Ubuntu.sh
source 1_install_packages_Ubuntu.sh
```

### 1.2 Create S3 bucket for saving terraform.tfstate. Download and run a script [2_create_S3bucket](1_environment/2_create_S3bucket.sh)

```
chmod +x 2_create_S3bucket.sh
./2_create_S3bucket.sh
```

### 1.3 Create folder /cicd/ and SSH-key with name "aws"

```
sudo mkdir /cicd
sudo ssh-keygen -f /cicd/aws
sudo chown jenkins:jenkins /cicd -R
```

### 1.4 In Jenkins

1.4.1 Jenkins ==> Manage Jenkins ==> Global Tool Configuration add information where installed:

- Terraform. Find where it installed:

```
whereis terraform
```

- Ansible. Find where it installed

```
which ansible
```

![](images/env_jenkins_global.jpg)

1.4.2 Jenkins ==> Manage Jenkins ==> Manage Credentials ==> (global) ==> Add credentials ==> AWS Credentials Add credentials to connect to AWS (ID: cicd-credentials)

1.4.3 Create Jenkins pipeline job, paste code from [Jenkinsfile](1_environment/Jenkinsfile) and run. The process of launching three servers using the Terraform and their configuration using the Ansible will begin.

## 2. Ansible server (public_2)

### 2.1 Exchange ssh-key

```bash
su *your_user_name* (ansiblecicd)
ssh-copy-id *private_ip_localhost* (private_2) #it's necessary to exchange the SSH-key with the local server on behalf of the created user
ssh-copy-id *private_ip_docker_server* (private_1)
```

### 2.2 Login to DockerHub:

```bash
docker login
```

### 2.3 Copy files to directory _(/opt/docker/)_:

- [Dockerfile](3_Ansible/Dockerfile)
- [3.3_playbook_push_image.yml](3_Ansible/3.3_playbook_push_image.yml)
- [3.4_playbook_run_container.yml](3_Ansible/3.4_playbook_run_container.yml)

---

## 4. Jenkins server (public_0)

### 4.1 Create trigger to automatically start a job in Jenkins, when some changes are made to the GitHub repository

- in settings GitHub repository with the project, specify the address of Jenkins-server and type of events to trigger this webhook _(http://ip_jenkins_server:8080/github-webhook/)_
  ![](images\webhook_git.jpg)

### 4.2 Manually configure Jenkins

- Manage Jenkins ==> Configure System ==> Publish over SSH add private IP address of Ansible-server (private_2), username and created user password.

  ![](images/ansible_ssh.jpg)

  > A better solution is to use an SSH key

- Manage Jenkins ==> Global Tool Configuration ==> configure GIT, JDK and Maven
  ![](images/glob_conf_1.jpg)

### 4.3 Create new Item (Maven project)

![](images/project_1.jpg)

> script to section "Exec command":

```
ansible-playbook -i/opt/docker/inventory.ini /opt/docker/3.3_playbook_push_image.yml;
sleep 10;
ansible-playbook -i/opt/docker/inventory.ini /opt/docker/3.4_playbook_run_container.yml;
```

---

## If you type in a link `http://ip_docker_server(public_1)/webapp` in a browser, you can see

![](images/registration_form.jpg)
