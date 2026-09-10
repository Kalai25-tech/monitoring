resource "aws_key_pair" "main" {
  key_name   = "oberservability-infra-key"
  public_key = file("modules/ec2/sshkeyfile.pub")
}

# grafana
module "grafana" {
  source               = "./modules/ec2"
  name                 = "grafana-server"
  ami                  = "ami-0f8a61b66d1accaee"
  instance_type        = "t3.micro"
  subnet_id            = data.aws_subnets.all.ids[0]
  security_group_ids   = [module.security_groups.app_sg_id]
  key_name             = aws_key_pair.main.key_name
  associate_public_ip  = true
  iam_instance_profile = module.iam.instance_profile_name
  user_data            = file("userdata/tomcat_ubuntu.sh")
  tags = {
    Tier = "app"
  }
}


# Prometheus
module "Prometheus" {
  source               = "./modules/ec2"
  name                 = "Prometheus-server"
  ami                  = "ami-0f8a61b66d1accaee"
  instance_type        = "t3.micro"
  subnet_id            = data.aws_subnets.all.ids[0]
  security_group_ids   = [module.security_groups.app_sg_id]
  key_name             = aws_key_pair.main.key_name
  associate_public_ip  = true
  iam_instance_profile = module.iam.instance_profile_name
  user_data            = file("userdata/tomcat_ubuntu.sh")
  tags = {
    Tier = "app"
  }
}