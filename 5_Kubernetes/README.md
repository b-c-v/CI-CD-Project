<!-- 5. Create IAM role for AWS Service (name k8s-role) ==> EC2 add Permissions policies:

- AmazonEC2FullAccess
- AWSCloudFormationFullAccess
- IAMFullAccess

1. Create EC2 instance. Name is K8s in same Secrity group with Jenkins, Ansible, Docker servers. Attach create role: Advanced detail ==> IAM instance profile ==> select created before role

2. Install last version of AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   #change hostname of server
   sudo hostnamectl set-hostname kubernetes

```
sudo -i #all install like root
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

3. Install kubectl

```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.7/2022-10-31/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
```

4. Install eksctl

```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
eksctl version
```

7. Create cluster (it takes about 20 minutes). In AWS CloudFromation can see crating new Stack

- Run command

```
eksctl create cluster --name k8s-cicd \
--region us-east-1 \
--node-type t2.small \
--zones us-east-1a,us-east-1b
```

8. Create deployment
   kubectl create deployment demo-nginx --image=nginx --port=80 --replicas=2

- show deployment
  kubectl get deployment

- show replicaset
  kubectl get replicaset

- show pods
  kubectl get pod

- show all
  kubectl get all

9. Create an ELB in front of 2 containers and allow to publicly acces them

kubectl expose deployment demo-nginx --port=80 --type=LoadBalancer

10. Delete what I created

kubectl delete deployment demo-nginx
kubectl delete service/demo-nginx

---

11. Create manifest file pod.yml
    kubectl apply -f pod.yml

12. Create service.yml
    kubectl apply -f service.yml

13. Delete pod and service
    kubectl delete pod demo-pod
    kubectl delete service/demo-service -->

---

2. Create IAM role for AWS Service (name k8s-role) ==> EC2 add Permissions policies:

- AmazonEC2FullAccess
- AWSCloudFormationFullAccess
- IAMFullAccess

1. Create EC2 instance. Name is K8s. Same secrity group with Jenkins, Ansible, Docker servers. Attach create role: Advanced detail ==> IAM instance profile ==> select created before role

   1.1 login as root:

sudo -i

- create password for root user

  passwd root

  1.1 Install last version of AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

1.2 Install kubectl

```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.7/2022-10-31/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
```

1.3 Install eksctl

```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /root/bin/eksctl
eksctl version
```

1.4.2 configure sshd_config

sudo vi /etc/ssh/sshd_config

- find lines:

```
# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication no
```

- and change them to:

```
# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes
#PermitEmptyPasswords no
#PasswordAuthentication no
```

- reload sshd

```
sudo service sshd reload
```

<!-- 1.4 add user and change password

```
sudo useradd ansiblecicd #username which created on Ansible-server
sudo passwd ansiblecicd
```

1.4.1 allow user ansiblecicd run sudo commands without password:

```
sudo visudo
```

- find line:

```
## Allow root to run any commands anywhere
root ALL=(ALL) ALL
```

- and add new line behind:

```
ansiblecicd ALL=(ALL) NOPASSWD: ALL
```


-->

3. K8s-server copy files cicd-deployment.yml and cicd-service.yml to folder **_/root/_**

- 3.1 Create cluster (it takes about 20 minutes). In AWS CloudFromation can see crating new Stack

- Run command

```
eksctl create cluster --name k8s-cicd \
--region us-east-1 \
--node-type t2.small \
--zones us-east-1a,us-east-1b
```

- Run command
  kubectl apply -f cicd-deployment.yml
  kubectl apply -f cicd-service.yml

- and by address http://LOAD_BALANCER_DNX:8080/webapp will see registration form
  http://af8f72e3bf84f4254b74dcf57e5e41c1-461086814.us-east-1.elb.amazonaws.com:8080/webapp/

9. run docker-server

10. run Ansible server in directory /opt/docker/ create files:

- change user to ansible:
  su ansiblecicd
- exchange ssh key (password to root user crated before)

  ```
  ssh-copy-id root@PRIVATE_IP_K8s-server
  ```

- hosts.ini and add information:

```
[kubernetes]
Private IP of K8s-server

[ansible]
Private IP of Ansible-server
```

- copy kube_deploy.ymlin directory /opt/docker/


11. In Jenkins
- create new Freestyle Project

