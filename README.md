# 7rsucvqgmn-imbsqs

# Requirement

Base on the requirement I need to create belows infrastructure component:
1. mysql with rds aurora
2. 2 SQS one for Queueing one for Publishing once service completed.
3. hosting the application service.

# assumption
1. the database schema and table will be setup and configure in application or apply sql outside this project
2. the logic consuming Queue and publish Topic will handle by application
3. using ecs (with fargate) as the hosting platform
4. assumption using http for POC purpose (need to change https with cert afterward)


# monitioring
1. ecs use cloudwatch log to save log from console
2. for sqs throughput can set cloudwatch alert and use sns send email (as sns for sending email did not create in this project for the cloudwatch alert just commented in sqs.tf)
3. For RDS mysql can check the metrics using cloudwatch and preformance insights and can set cloudwatch alert for critical resource usage

# terraform

# Initial setup

1. install terraform ( https://www.terraform.io/downloads.html )


# Config Terraform before execute
1. edit `backend.tf` if you have s3 bucket to store the state
2. edit `<environmentname>.tfvars`


# Terraform execute

1. if first time to use terraform you need to run , it will help you to install the provider 
```bash
terraform init
```

3. check syntax of script before execute
```bash
terraform plan -var-file <workspacename>.tfvars
```

3. execute script to create all resource
```bash
terraform apply -var-file <workspacename>.tfvars
```
4. remove all resource
```bash
terraform destroy -var-file <workspacename>.tfvars

```
5. remove target resource
```bash
terraform destroy -target <resource name> -var-file <workspacename>.tfvars
```
for example I want to remove the security group, from `ecs.tf` find the resource block:
``` tf
resource "aws_security_group" "service_security_group" {
  ...
  tags = {
    Project = var.project_name
  }
}
```
the `<resource name>` is `aws_security_group.service_security_group`

