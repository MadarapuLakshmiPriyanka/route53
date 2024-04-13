resource "aws_vpc" "dev" {
  cidr_block = var.cidr_block
  enable_dns_hostnames=true
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id
  tags = {
    "Name" = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "publicsubnet" {
  count = 3
  vpc_id = aws_vpc.dev.id
  map_public_ip_on_launch=true
  cidr_block = element(var.cidr_block_publicsubnet,count.index)
  availability_zone = element(var.avzs,count.index)
  tags = {
    "Name" = "${var.vpc_name}-publicsubnet"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "${var.vpc_name}-publicrt"
  }
}

resource "aws_route_table_association" "rtassoc" {
  count = 3
  subnet_id = element(aws_subnet.publicsubnet.*.id,count.index)
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.dev.id
  name = "priyasg"
  description = "sg creation"
  ingress {
    to_port = 0
    from_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.vpc_name}-sg"
  }
}

