##########  For aws provider ##########

variable "region" {
  type        = string
  description = "Target Region"
}
variable "access_key" {
  type        = string
  description = "access key"
}
variable "secret_key" {
  type        = string
  description = "secret key"
}

########################################

########### Pre-define VPC and Subnet  #############

variable "predefine_vpc_id" {
  type = string
}
variable "predefine_subnet_id" {
  type = string
}

######################################################

variable "project_name" {
  type = string
}

################# RDS ##################
variable "rds_name" {
  type = string
}
variable "rds_engine" {
  type = string
}
variable "rds_engine_version" {
  type = string
}
variable "rds_availability_zones" {
  type = list(string)
}
variable "rds_database_name" {
  type = string
}
variable "rds_master_username" {
  type = string
}
variable "rds_master_password" {
  type = string
}
variable "rds_backup_retention_period" {
  type = number
}
variable "rds_preferred_backup_window" {
  type = string
}
variable "rds_instance_class" {
  type = string
}
variable "rds_cluster_parameter_group_family_name" {
  type = string
}
variable "rds_cluster_parameter_parameters" {
  type = list(object({
    name            = string,
    value            = string
  }))
}
########################################


###################### SQS #######################

variable "sqs_queue_name" {
  type = string
}
variable "sqs_queue_delay_seconds" {
  type = number
}
variable "sqs_queue_max_message_size" {
  type = number
}
variable "sqs_queue_message_retention_seconds" {
  type = number
}
variable "sqs_queue_receive_wait_time_seconds" {
  type = number
}
variable "sqs_topic_name" {
  type = string
}
variable "sqs_topic_delay_seconds" {
  type = number
}
variable "sqs_topic_max_message_size" {
  type = number
}
variable "sqs_topic_message_retention_seconds" {
  type = number
}
variable "sqs_topic_receive_wait_time_seconds" {
  type = number
}
###################################################



########################## ECS ###########################

variable "ecr_repo_name" {
  type = string
}
variable "ecr_image_tag" {
  type = string
}
variable "ecs_application_name" {
  type = string
}
variable "ecs_application_containerPort" {
  type = string
}
variable "ecs_application_memory" {
  type = string
}
variable "ecs_application_cpu" {
  type = string
}
variable "ecs_application_desired_count" {
  type = number
}
variable "ecs_health_check_status_code" {
  type = string
}
variable "ecs_health_check_path" {
  type = string
}

############################################################