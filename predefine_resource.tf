data "aws_vpc" "vpc" {
  id = var.predefine_vpc_id
}

data "aws_subnet" "subnet_a" {
  id = var.predefine_subnet_a_id
}
data "aws_subnet" "subnet_b" {
  id = var.predefine_subnet_b_id
}
data "aws_subnet" "subnet_c" {
  id = var.predefine_subnet_c_id
}