resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-serverless-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.05.2"
  database_name           = "alloydb"
  master_username        = jsondecode(data.aws_secretsmanager_secret_version.db_password_version.secret_string)["username"]
  master_password        = jsondecode(data.aws_secretsmanager_secret_version.db_password_version.secret_string)["password"]
  iam_database_authentication_enabled = true
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  skip_final_snapshot     = true
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

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier         = "aurora-serverless-v2-instance"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
  engine            = aws_rds_cluster.aurora.engine
  engine_version    = aws_rds_cluster.aurora.engine_version
}

