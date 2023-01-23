resource "aws_security_group" "postgres" {
  name   = "${var.cluster_name}-postgres-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 5432
    security_groups = [module.eks.worker_security_group_id, aws_security_group.bastion.id]
  }
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "lynxpostgres"

  engine            = "postgres"
  engine_version    = "12"
  instance_class    = "db.t3.medium"
  allocated_storage = 5
  storage_encrypted = false

  name = "lynx"

  username = "lynxuser"

  password = var.pg_password
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.postgres.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags                     = { "tigera.fr/environment" = var.cluster_name,
                               "tigera.fr/role" = "db"
                             }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "postgres12"

  # DB option group
  major_engine_version = "12"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = null

  snapshot_identifier = null
  # Database Deletion Protection
  deletion_protection = false
}
