#create vpc
resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc"
  }
}

#create igw and attach to vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "igw"
  }
}

# creating subnets
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

# creating route tables and providing internet
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.custom.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#subnet association 

resource "aws_route_table_association" "rtass" {
  route_table_id = aws_route_table.RT.id
  subnet_id      = aws_subnet.subnet.id
}

#creating custom security group

resource "aws_security_group" "sg" {
  name   = "sgforvpc"
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "sg"
  }
  ingress {
    description = "traffic from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "traffic from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
