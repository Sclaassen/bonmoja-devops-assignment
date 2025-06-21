## This module creates an Internet Gateway for a VPC in AWS.

resource "aws_internet_gateway" "vpc-internet-gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-main-igw"
  }
}
