resource "aws_vpc" "main" {
  cidr_block       = var.vpc_ip
  instance_tenancy = "default"

  tags = {
    Name = "${var.app_name}"
  }
}

# Internet gateway 
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}"
  }
}

# Public subnet 1
resource "aws_subnet" "public-1" {
  availability_zone = "ap-south-1a"
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_ip

  tags = {
    Name = "${var.app_name}"
  }
}

# Public subnet 2
resource "aws_subnet" "public-2" {
  availability_zone = "ap-south-1b"
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_ip2

  tags = {
    Name = "${var.app_name}"
  }
}

# Public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.ig.id
    }
    tags = {
        Name = "${var.app_name}"
    }
}

# Public route table & public-subnet-1
resource "aws_route_table_association" "rta-public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-rt.id
}

# Public route table & public-subnet-2 
resource "aws_route_table_association" "rta-public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-rt.id
}

# Elastic IP.
resource "aws_eip" "nat" {
    vpc      = true
}

# Nat gateway 
resource "aws_nat_gateway" "gw" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public-1.id
    tags = {
        Name = "${var.app_name}"
    }
}

# Private subnet.
resource "aws_subnet" "private-1" {
  availability_zone = "ap-south-1a"
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_ip

  tags = {
    Name = "${var.app_name}"
  }
}

# Private route table  
resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.gw.id  #nat gateway
    }
    tags = {
        Name = "${var.app_name}"
    }
}

# private subnet & private route table.
resource "aws_route_table_association" "rta-private-1" {
    subnet_id      = aws_subnet.private-1.id
    route_table_id = aws_route_table.private-rt.id
}

# Security group ELB
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow internet traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-alb-sg"
  }
}

# Security group EC2 
resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Allow all traffic "
  vpc_id      = aws_vpc.main.id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.app_name}"
  }
}
