resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-serverless-cluster"
  engine                  = "aurora-mysql"
  engine_mode             = "provisioned"
  database_name           = "mydb"
  master_username         = "admin"
  master_password         = "MySecurePass123!"
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  skip_final_snapshot     = true

  scaling_configuration {
    min_capacity = 0.5
    max_capacity = 2
    auto_pause   = true
    seconds_until_auto_pause = 300
  }

  enable_http_endpoint = true
}

resource "aws_db_subnet_group" "aurora" {
  name       = "aurora-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_security_group" "aurora_sg" {
  name        = "aurora_sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow ECS Fargate access"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
