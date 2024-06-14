module "vpc" {
  source = "./modules/vpc"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source             = "./modules/route_table"
  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.subnet.subnet_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.subnet.subnet_id
  security_group_id = module.security_group.security_group_id
}

module "s3" {
  source            = "./modules/s3"
 }
 
 module "dynamoDB" {
  source            = "./modules/dynamoDB"
 }
 
module "sns" {
  source          = "./modules/sns"
  email_endpoint  = "saeedkouta@gmail.com"
}

 
module "cloudwatch" {
  source             = "./modules/cloudwatch"
  instance_id        = module.ec2.instance_id
  alarm_sns_topic_arn = module.sns.sns_topic_arn
  cpu_threshold      = 60
  memory_threshold   = 60
  disk_threshold     = 60
}


