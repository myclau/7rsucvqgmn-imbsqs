locals {
    rds_read_name                       = "${var.rds_name}-read"
    rds_write_name                      = "${var.rds_name}-write"
    rds_read_endpoint_name              = "${var.rds_name}-read-endpoint"
    rds_write_endpoint_name             = "${var.rds_name}-write-endpoint"
    rds_cluster_parameter_group_name    = "${var.rds_name}-pg"
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier      = var.rds_name
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  availability_zones      = var.rds_availability_zones
  database_name           = var.rds_database_name
  master_username         = var.rds_master_username
  master_password         = var.rds_master_password
  backup_retention_period = var.rds_backup_retention_period
  preferred_backup_window = var.rds_preferred_backup_window
  tags = {
    Project = var.project_name
  }
}



resource "aws_rds_cluster_instance" "rds_read" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.rds.id
  identifier         = local.rds_read_name
  instance_class     = var.rds_instance_class
  engine             = aws_rds_cluster.rds.engine
  engine_version     = aws_rds_cluster.rds.engine_version
  tags = {
    Project = var.project_name
  }
}
resource "aws_rds_cluster_instance" "rds_write" {
  apply_immediately  = true
  cluster_identifier = aws_rds_cluster.rds.id
  identifier         = local.rds_write_name
  instance_class     = var.rds_instance_class
  engine             = aws_rds_cluster.rds.engine
  engine_version     = aws_rds_cluster.rds.engine_version
  tags = {
    Project = var.project_name
  }
}


resource "aws_rds_cluster_endpoint" "rds_read_endpoint" {
  cluster_identifier          = aws_rds_cluster.rds.id
  cluster_endpoint_identifier = local.rds_read_endpoint_name
  custom_endpoint_type        = "READER"

  static_members = [
    aws_rds_cluster_instance.rds_read.id
  ]
  tags = {
    Project = var.project_name
  }
}

resource "aws_rds_cluster_endpoint" "rds_write_endpoint" {
  cluster_identifier          = aws_rds_cluster.rds.id
  cluster_endpoint_identifier = local.rds_write_endpoint_name
  custom_endpoint_type        = "WRITER"

  static_members = [
    aws_rds_cluster_instance.rds_write.id
  ]
  tags = {
    Project = var.project_name
  }
}

resource "aws_rds_cluster_parameter_group" "default" {
  name        = local.rds_cluster_parameter_group_name
  family      = var.rds_cluster_parameter_group_family_name
  description = "${var.rds_name} default cluster parameter group"

  dynamic "parameter" {
    for_each = var.rds_cluster_parameter_parameters
    iterator = pp
    content {
      name      = pp.value.name
      value     = pp.value.value
    }
  }
  tags = {
    Project = var.project_name
  }
}