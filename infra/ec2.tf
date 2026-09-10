resource "aws_key_pair" "main" {
  key_name   = "3tier-infra-key"
  public_key = file("modules/ec2/sshkeyfile.pub")
}

# Tomcat
module "tomcat" {
  source               = "./modules/ec2"
  name                 = "tomcat-app-server"
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

# Mysql
module "mysql" {
  source              = "./modules/ec2"
  name                = "mysql-app-server"
  ami                 = "ami-0332d564d76dbd8d6"
  instance_type       = "t3.micro"
  subnet_id           = data.aws_subnets.all.ids[0]
  security_group_ids  = [module.security_groups.backend_sg_id]
  key_name            = aws_key_pair.main.key_name
  associate_public_ip = true
  user_data           = file("userdata/mysql.sh")
  tags = {
    Tier = "Backend"
  }
}

# Rabbitmq
module "rabbitmq" {
  source              = "./modules/ec2"
  name                = "rabbitmq-app-server"
  ami                 = "ami-0332d564d76dbd8d6"
  instance_type       = "t3.micro"
  subnet_id           = data.aws_subnets.all.ids[0]
  security_group_ids  = [module.security_groups.backend_sg_id]
  key_name            = aws_key_pair.main.key_name
  associate_public_ip = true
  user_data           = file("userdata/rabbitmq.sh")
  tags = {
    Tier = "Backend"
  }
}

# Memcached
module "memcache" {
  source              = "./modules/ec2"
  name                = "memcache-app-server"
  ami                 = "ami-0332d564d76dbd8d6"
  instance_type       = "t3.micro"
  subnet_id           = data.aws_subnets.all.ids[0]
  security_group_ids  = [module.security_groups.backend_sg_id]
  key_name            = aws_key_pair.main.key_name
  associate_public_ip = true
  user_data           = file("userdata/memcache.sh")
  tags = {
    Tier = "Backend"
  }
}
