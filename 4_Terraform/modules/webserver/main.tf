resource "aws_security_group" "cicd_sg" {
  name        = "cicd-security-group"
  description = "Allow HTTP (80), TCP (8080) and SSH(22) in VPC"
  vpc_id      = var.ws_vpc_id

  ingress {
    description = "CICD SSH to VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ws_my_ip]
  }

  ingress {
    description = "CICD HTTP to VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "CICD TCP to VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ws_env_prefix}-ports"
  }
}

data "aws_ami" "latest_amazon_linux_image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = [var.ws_webserver_image_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_key_pair" "ssh-key" {
  key_name   = "${var.ws_env_prefix}-key"
  public_key = file(var.ws_my_publick_key_location) #use public key, and it will possible to connect to instance with ssh ec2-user@<ip_instanc> without any additional passwords
}

resource "aws_instance" "cicd_private_server" {
  ami                    = data.aws_ami.latest_amazon_linux_image.id
  instance_type          = var.ws_instance_type
  count                  = 1 #amount of created EC2 instances
  subnet_id              = var.ws_subnet_id
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  availability_zone      = var.ws_avail_zone

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.ws_env_prefix}-ansible-server"
  }
}

resource "aws_instance" "cicd_public_server" {
  ami                    = data.aws_ami.latest_amazon_linux_image.id
  instance_type          = var.ws_instance_type
  count                  = 2 #amount of created EC2 instances
  subnet_id              = var.ws_subnet_id
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]
  availability_zone      = var.ws_avail_zone

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.ws_env_prefix}-public-server-${count.index}"
  }
}
