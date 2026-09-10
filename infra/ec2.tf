resource "aws_key_pair" "main" {
  key_name   = "oberservability-infra-key"
  public_key = file("modules/ec2/sshkeyfile.pub")
}

# grafana
module "grafana" {
  source              = "./modules/ec2"
  name                = "grafana-server"
  ami                 = "ami-0f8a61b66d1accaee"
  instance_type       = "t3.micro"
  subnet_id           = data.aws_subnets.all.ids[0]
  security_group_ids  = [module.security_groups.grafana_sg_id]
  key_name            = aws_key_pair.main.key_name
  associate_public_ip = true
  user_data           = file("userdata/grafana-setup.sh")
  tags = {
    Tier = "grafana"
  }
}


# Prometheus
module "prometheus" {
  source              = "./modules/ec2"
  name                = "prometheus-server"
  ami                 = "ami-0f8a61b66d1accaee"
  instance_type       = "t3.micro"
  subnet_id           = data.aws_subnets.all.ids[0]
  security_group_ids  = [module.security_groups.prometheus_sg_id]
  key_name            = aws_key_pair.main.key_name
  associate_public_ip = true
  user_data           = file("userdata/prometheus-setup.sh")
  tags = {
    Tier = "Prometheus"
  }
}

# loki
module "loki" {
  source              = "./modules/ec2"
  name                = "loki-server"
  ami                 = "ami-0f8a61b66d1accaee"
  instance_type       = "t3.micro"
  subnet_id           = data.aws_subnets.all.ids[0]
  security_group_ids  = [module.security_groups.loki_sg_id]
  key_name            = aws_key_pair.main.key_name
  associate_public_ip = true
  user_data           = file("userdata/lokisetup.sh")
  tags = {
    Tier = "Prometheus"
  }
}

# webserver
module "webserver" {
  source              = "./modules/ec2"
  name                = "webserver"
  ami                 = "ami-0f8a61b66d1accaee"
  instance_type       = "t3.micro"
  subnet_id           = data.aws_subnets.all.ids[0]
  security_group_ids  = [module.security_groups.webserver_sg_id]
  key_name            = aws_key_pair.main.key_name
  associate_public_ip = true
  user_data           = file("userdata/webnode_setup.sh")
  tags = {
    Tier = "webserver"
  }
}