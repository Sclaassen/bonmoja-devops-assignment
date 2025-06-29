## This Terraform module sets up an RDS PostgreSQL database instance with a subnet group and security groups.

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.environment}-rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.subnet_ids
  tags = {
    Environment = "${var.environment}"
  }
}

/* Security Group for resources that want to access the Database */
resource "aws_security_group" "db_access_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.environment}-db-access-sg"
  description = "Allow access to RDS"

  tags = {
    Name        = "${var.environment}-db-access-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-rds-sg"
  description = "${var.environment} Security Group"
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = "${var.environment}"
  }

  // allows traffic from the SG itself
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  // allow traffic for TCP 5432 from db_access_sg and ecs_sg
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.db_access_sg.id, var.ecs_security_group_id]
  }

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier                      = "${var.environment}-database"
  allocated_storage               = var.allocated_storage
  engine                          = "postgres"
  engine_version                  = "17.5"
  instance_class                  = var.instance_class
  multi_az                        = var.multi_az
  db_name                         = var.database_name
  username                        = var.database_username
  password                        = var.database_password
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids          = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  region                          = var.aws_region
  tags = {
    Name        = "${var.environment}-rds-instance"
    Environment = "${var.environment}"
  }

}