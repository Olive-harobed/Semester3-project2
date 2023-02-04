variable "region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC to use"
}

variable "public_subnet_names" {
  type        = list(string)
  description = "The names of the public subnets to filter for"
}

variable "instance_count" {
  default = 3
}


variable "ami_id" {
  type        = string
  description = "The ID of the AMI to use for the EC2 instances"
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group to update"
}


variable "alb_name" {
type = string
}

variable "alb_security_group" {
  type = string
}

variable "security_group_rule_cidr_blocks" {
  type = list(string)
}

variable "target_group_name" {
  type = string
}


variable "ssh_key" {
  description = "SSH key name"
  type = string
}
variable "connection_user" {
  type    = string
}

variable "connection_private_key_path" {
  type    = string
}

variable "connection_timeout" {
  type    = string
}
# route 53
variable "domain_names" {
  description = "list domain name and subdomain name"
  type = map(string)
}
variable "token" {
  description = "Name.com API token"
  type = string
}

variable "username" {
  description = "Name.com username"
  type = string
}