resource "aws_vpc" "main" {
  cidr_block           = "16.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name"        = "${var.owner}-vpc"
    "ServiceName" = var.service_name
    "Provisioner" = "Terraform"
    "bootcamp"    = "devops"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name"        = "${var.owner}-igw"
    "ServiceName" = var.service_name
    "Provisioner" = "Terraform"
    "bootcamp"    = "devops"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    "Name"        = "${var.owner}-public-rt"
    "ServiceName" = var.service_name
    "Provisioner" = "Terraform"
    "bootcamp"    = "devops"
  }
}

resource "aws_route_table_association" "subnet" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "16.0.1.0/24"


  tags = {
    "Name"        = "${var.owner}-subnet"
    "ServiceName" = var.service_name
    "Provisioner" = "Terraform"
    "bootcamp"    = "devops"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "${var.owner}-${var.service_name}-webserver-sg"
  description = "Security Group for Jenkins Instance"
  vpc_id      = aws_vpc.main.id


  tags = {
    "Name"        = "${var.owner}-sg"
    "ServiceName" = var.service_name
    "Provisioner" = "Terraform"
    "bootcamp"    = "devops"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule" {
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Rule for SSH Access"

  cidr_ipv4   = "181.61.89.105/32"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "custom_tcp_rule" {
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Rule for Custom tcp Access"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080
}

resource "aws_vpc_security_group_egress_rule" "custom_tcp_rule" {
  security_group_id = aws_security_group.jenkins_sg.id
  description       = "Rule for Custom tcp Access"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"

  key_name                    = "juan-jenkins"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
                    #!/bin/bash
                    # Install Jenkins
                    sudo yum update -y
                    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
                    sudo yum upgrade
                    sudo yum install java-17-amazon-corretto -y
                    sudo yum install jenkins -y
                    sudo systemctl start jenkins
                    EOF
  tags = {
    "Name"        = "${var.owner}-${var.service_name}"
    "ServiceName" = var.service_name
    "Provisioner" = "Terraform"
    "bootcamp"    = "devops"
  }
}

