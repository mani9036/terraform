provider "aws" {
  region = var.location
}

resource "aws_instance" "server" {
 ami = var.os_name
 key_name = var.key 
 instance_type  = var.instance-type
 associate_public_ip_address = true
subnet_id = aws_subnet.subnet-1.id
vpc_security_group_ids = [aws_security_group.vpc-sg.id]
}

// Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
}

// Create Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc.id 
  cidr_block = var.subnet1-cidr
  availability_zone = var.subent_az-1
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet"
  }
}


// Create Subnet
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.vpc.id 
  cidr_block = var.subnet2-cidr
  availability_zone = var.subent_az-2
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet"
  }
}

// Create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt"
  }
}

// associate subnet with route table 
resource "aws_route_table_association" "rt_association-1" {
  subnet_id      = aws_subnet.subnet-1.id 

  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rt_association-2" {
  subnet_id      = aws_subnet.subnet-2.id 

  route_table_id = aws_route_table.rt.id
}
// create a security group 

resource "aws_security_group" "vpc-sg" {
  name        = "vpc-sg"
 
  vpc_id      = aws_vpc.vpc.id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

module "sgs" {
  source = "./sg_eks"
  vpc_id = aws_vpc.vpc.id
}

module "eks"{
  source = "./eks"
  sg_ids = module.sgs.security_group_public
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.subnet-1.id,aws_subnet.subnet-2.id]
}
