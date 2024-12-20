# Common vars
team        = "infra"
component   = "tf"
region      = "us-east-1"
environment = "develop"

# Networking
## vpc
vpc_cidr        = "10.0.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
