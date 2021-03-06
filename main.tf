data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
}

module "http_80_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/http-80"
  version             = "3.16.0"
  name                = "Web-Access"
  vpc_id              = data.aws_vpc.default_vpc.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "2.15.0"
  name                   = "my-instance"
  ami                    = var.amazon_linux_2_ami_id
  instance_type          = "t2.micro"
  key_name               = "Frankfurt-kp"
  subnet_id              = sort(data.aws_subnet_ids.vpc_subnets.ids)[0]
  vpc_security_group_ids = [module.http_80_security_group.this_security_group_id]
  user_data = file("./shell/http-server.sh")
}
