## This module creates a Route Table for a VPC in AWS.
resource "aws_route_table" "vpc-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-internet-gateway.id
  }

  tags = {
    Name = "${var.environment}-vpc-route-table"
  }
}

resource "aws_route_table_association" "vpc-public-route-table-association1" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.vpc-route-table.id
}

resource "aws_route_table_association" "vpc-public-route-table-association2" {
  subnet_id      = aws_subnet.public[1].id
  route_table_id = aws_route_table.vpc-route-table.id
}