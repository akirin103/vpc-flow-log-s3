locals {
  public_key_path = "~/.ssh/id_rsa.pub"
}

data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

module "server" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "4.0.0"
  name                        = "${var.system_name}-${var.env}-server"
  ami                         = data.aws_ssm_parameter.this.value
  instance_type               = var.instance_type
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name
  tags                        = local.tags
}

resource "aws_key_pair" "this" {
  key_name   = "${var.system_name}-${var.env}-key-pair"
  public_key = file(local.public_key_path)
  tags       = local.tags
}
