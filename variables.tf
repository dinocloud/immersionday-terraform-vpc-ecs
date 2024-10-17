#General variables
variable "region" {
  description = "The region in which the VPC will be created"
  type        = string
}

variable "team" {
  description = "The team name"
  type        = string
}
variable "component" {
  description = "The component name"
  type        = string
}
variable "environment" {
  description = "The environment name"
  type        = string
}
# Networking variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}
variable "enable_nat_gateway" {
  description = "A boolean flag to enable/disable NAT Gateways for the private subnets"
  type        = bool
  default     = true
}
