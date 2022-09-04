data "aws_availability_zones" "this" {
  state = "available"
}

module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "3.14.2"
  name           = "${var.system_name}-${var.env}-vpc"
  cidr           = "10.0.0.0/16"
  azs            = data.aws_availability_zones.this.names
  public_subnets = ["10.0.0.0/24"]
  tags           = local.tags
}

resource "aws_flow_log" "this" {
  log_destination      = aws_s3_bucket.this.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
  destination_options {
    file_format        = "plain-text"
    per_hour_partition = true
  }
}
