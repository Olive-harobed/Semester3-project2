terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 4.0"
}
namedotcom = {
source = "lexfrei/namedotcom"
version = "1.2.4"
}
}
}

provider "aws" {
region = var.region
}

provider "namedotcom" {
  token = var.token
  username = var.username
}



data "aws_vpc" "selected" {
id = var.vpc_id
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
}