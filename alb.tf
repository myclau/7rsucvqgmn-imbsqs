locals{
    alb_name="${var.ecs_application_name}-alb"
}

resource "aws_alb" "application_load_balancer" {
  name               = local.alb_name # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    "${data.aws_subnet.subnet_a.id}",
    "${data.aws_subnet.subnet_b.id}",
    "${data.aws_subnet.subnet_c.id}"
  ]
  # Referencing the security group
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  tags = {
    Project = var.project_name
  }
}

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = var.ecs_application_containerPort # Allowing traffic in from port 80
    to_port     = var.ecs_application_containerPort
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
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

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = var.ecs_application_containerPort
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_vpc.vpc.id}"
  health_check {
    matcher = var.ecs_health_check_status_code
    path = var.ecs_health_check_path
  }
  tags = {
    Project = var.project_name
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}" # Referencing our load balancer
  port              = var.ecs_application_containerPort
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our tagrte group
  }
  tags = {
    Project = var.project_name
  }
}