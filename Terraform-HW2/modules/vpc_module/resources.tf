locals {
  creationDateTime = formatdate("DD MMM YYYY - HH:mm AA ZZZ", timestamp())
}

# Creating a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.main_cidr_block
  tags = {
    "Name" = "kmTFvpc"
    "CreationDateTime" = local.creationDateTime
  }
}

# Creating an Internet Gateway
resource "aws_internet_gateway" "igateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "kmTFigateway"
    "CreationDateTime" = local.creationDateTime
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(data.aws_availability_zones.availableAZ.names)
  availability_zone = data.aws_availability_zones.availableAZ.names[count.index]
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.main_cidr_block,4,count.index)
  tags = {
    "Name" = "kmTFpbsubnet${count.index}"
    "CreationDateTime" = local.creationDateTime
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(data.aws_availability_zones.availableAZ.names)
  availability_zone = data.aws_availability_zones.availableAZ.names[count.index]
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.main_cidr_block,4,count.index+4)
  tags = {
    "Name" = "kmTFpvsubnet${count.index}"
    "CreationDateTime" = local.creationDateTime
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
    "CreationDateTime" = local.creationDateTime
  }
}

# Associating public subnets to public route table

resource "aws_route_table_association" "public_rt" {
  count = length(data.aws_availability_zones.availableAZ.names)
  subnet_id = element(aws_subnet.public_subnets.*.id,count.index)
  route_table_id = aws_route_table.pbRT.id
}

# Create Ellastic IP

resource "aws_eip" "eip1" {
  depends_on = [aws_internet_gateway.igateway]
  tags = {
    "Name" = "kmTFeip"
    "CreationDateTime" = local.creationDateTime
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "natgtw" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = element(aws_subnet.public_subnets.*.id,0)

  tags = {
    "Name" = "kmTFnatgtw"
    "CreationDateTime" = local.creationDateTime
  }
}

# Creating a Private Route Table

resource "aws_route_table" "pvRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgtw.id
  }

  tags = {
    "Name" = "kmTFpvrt"
    "CreationDateTime" = local.creationDateTime
  }
}

# Associating private subnets to private route table

resource "aws_route_table_association" "private_rt" {
  count = length(data.aws_availability_zones.availableAZ.names)
  subnet_id = element(aws_subnet.private_subnets.*.id,count.index)
  route_table_id = aws_route_table.pvRT.id
}