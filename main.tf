provider "aws" {
  region = "us-east-1"
}
variable "owner" {
  description = "Owner of the resources"
  type        = string
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags ={
    Environment ="terraformChamps"
    owner= var.owner
  }
}
  resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
      Environment ="terraformChamps"
    owner= var.owner
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
     Environment ="terraformChamps"
    owner= var.owner
  }
}
resource "aws_egress_only_internet_gateway" "egress_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = "terraformChamps"
    owner       = var.owner
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress_gw.id
  }

  tags = {
  Environment = "terraformChamps"
    owner       = var.owner
  }
}


