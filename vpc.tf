data "aws_vpc" "demo_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.demo_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = var.public_subnet_names
  }
}
