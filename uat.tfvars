##########  For aws provider ##########

region     = "ap-east-1"
access_key = "xxxxxxxxxxxxxxxxxx"
secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

########################################

########### Pre-define VPC and Subnet  #############

predefine_vpc_id     = "vpc-xxxxxxxxxxxxxxxxxxxxx"
predefine_subnet_a_id  = "subnet-xxxxxxxxxxxxxxxxxxxxx"
predefine_subnet_b_id  = "subnet-xxxxxxxxxxxxxxxxxxxxx"
predefine_subnet_c_id  = "subnet-xxxxxxxxxxxxxxxxxxxxx"

#############################################################

project_name = sample-queue-system

################# RDS ##################
rds_name                                = "aurora-mysql01"
rds_engine                              = "aurora-mysql"
rds_engine_version                      = "5.7.mysql_aurora.2.03.2"
rds_availability_zones                  = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
rds_database_name                       = "db01"
rds_master_username                     = "admin"
rds_master_password                     = "p@ssw0rd"
rds_backup_retention_period             = 5
rds_preferred_backup_window             = "07:00-09:00"
rds_instance_class                      = "db.t2.small"
rds_cluster_parameter_group_family_name = "aurora5.7"
rds_cluster_parameter_parameters        = [
  {
    name  = "character_set_server"
    value = "utf8"
  },
  {
    name  = "character_set_client"
    value = "utf8"
  }
]
########################################


###################### SQS #######################

sqs_queue_name                      = "notification.fcm"
sqs_queue_delay_seconds             = 90
sqs_queue_max_message_size          = 2048
sqs_queue_message_retention_seconds = 86400
sqs_queue_receive_wait_time_seconds = 10

sqs_topic_name                      = "notification.done"
sqs_topic_delay_seconds             = 90
sqs_topic_max_message_size          = 2048
sqs_topic_message_retention_seconds = 86400
sqs_topic_receive_wait_time_seconds = 10

###################################################



########################## ECS ###########################

ecr_repo_name                   = "imbee-secret-fcm"
ecr_image_tag                   = "1.0.2"
ecs_application_name            = "imbee-secret-fcm"
ecs_application_containerPort   = "8080"
ecs_application_memory          = "512"
ecs_application_cpu             = "256"
ecs_application_desired_count   = 3
ecs_health_check_status_code    = "200,301,302"
ecs_health_check_path           = "/"
############################################################