locals{
    ecs_task_definition_name            = "${var.ecs_application_name}-task"
    ecs_service_name                    = "${var.ecs_application_name}-service"
    ecs_kms_key_name                    = "${var.ecs_application_name}-kms-key"
    ecs_cloudwatch_log_group_name       = "${var.ecs_application_name}-cloudwatch-log-group"
    ecs_kms_key_deletion_window_in_days = 7
}
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_application_name
  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.kms_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cloudwatch_log_group.name
      }
    }
  }
}

data "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repo_name
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = local.ecs_task_definition_name
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${local.ecs_task_definition_name}",
      "image": "${data.aws_ecr_repository.ecr_repo.repository_url}:${var.ecr_image_tag}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.ecs_application_containerPort},
          "hostPort": ${var.ecs_application_containerPort}
        }
      ],
      "memory": ${var.ecs_application_memory},
      "cpu": ${var.ecs_application_cpu}
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.ecs_application_memory   # Specifying the memory our container requires
  cpu                      = var.ecs_application_cpu   # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_service" "ecs_service" {
  name            = local.ecs_service_name                             # Naming our first service
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = var.ecs_application_desired_count # Setting the number of containers to 3

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
    container_name   = "${aws_ecs_task_definition.ecs_task.family}"
    container_port   = var.ecs_application_containerPort # Specifying the container port
  }

  network_configuration {
    subnets          = ["${data.aws_subnet.subnet_a.id}", "${data.aws_subnet.subnet_b.id}", "${data.aws_subnet.subnet_c.id}"]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
  }
  tags = {
    Project = var.project_name
  }
}


resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
  tags = {
    Project = var.project_name
  }
}

resource "aws_kms_key" "kms_key" {
  description             = local.ecs_kms_key_name
  deletion_window_in_days = local.ecs_kms_key_deletion_window_in_days
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = local.ecs_cloudwatch_log_group_name
}
