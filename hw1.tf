terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }
  }
}

# Choosing region
provider "aws" {
  region = "us-west-2"
}

# Creating a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "150.10.0.0/16"
  tags = {
    "Name" = "kmTFvpc"
  }
}

# Creating an Internet Gateway
resource "aws_internet_gateway" "igateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "kmTFigateway"
  }
}

# Creating public subnets
resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "150.10.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "kmTFpbsubnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "150.10.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    "Name" = "kmTFpbsubnet2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "150.10.3.0/24"
  availability_zone = "us-west-2c"
  tags = {
    "Name" = "kmTFpbsubnet3"
  }
}

# Creating private subnets
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "150.10.4.0/24"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "kmTFpvsubnet1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "150.10.5.0/24"
  availability_zone = "us-west-2b"
  tags = {
    "Name" = "kmTFpvsubnet2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "150.10.6.0/24"
  availability_zone = "us-west-2c"
  tags = {
    "Name" = "kmTFpvsubnet3"
  }
}

# Creating a Public Route Table

resource "aws_route_table" "pbRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igateway.id
  }

  tags = {
    "Name" = "kmTFpbrt"
  }
}

# Associating public subnets to public route table

resource "aws_route_table_association" "pbs1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.pbRT.id
}

resource "aws_route_table_association" "pbs2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.pbRT.id
}

resource "aws_route_table_association" "pbs3" {
  subnet_id = aws_subnet.public3.id
  route_table_id = aws_route_table.pbRT.id
}

# Create Ellastic IP

resource "aws_eip" "eip1" {
  depends_on = [aws_internet_gateway.igateway]
  tags = {
    "Name" = "kmTFeip"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "natgtw" {
  allocation_id = aws_eip.eip1.id
  subnet_id = aws_subnet.public1.id

  tags = {
    "Name" = "kmTFnatgtw"
  }
}

# Creating a Private Route Table

resource "aws_route_table" "pvRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgtw.id
  }

  tags = {
    "Name" = "kmTFpvrt"
  }
}

# Associating private subnets to private route table

resource "aws_route_table_association" "pvs1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.pvRT.id
}

resource "aws_route_table_association" "pvs2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.pvRT.id
}

resource "aws_route_table_association" "pvs3" {
  subnet_id = aws_subnet.private3.id
  route_table_id = aws_route_table.pvRT.id
}

