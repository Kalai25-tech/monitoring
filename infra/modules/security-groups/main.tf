resource "aws_security_group" "lb" {
  name   = "lb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "lb-sg"
  }
}

resource "aws_security_group" "app" {
  name   = "app-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "app-sg"
  }
}

resource "aws_security_group" "backend" {
  name   = "backend-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "backend-sg"
  }

}


# lb_http

resource "aws_vpc_security_group_ingress_rule" "lb_http" {
  security_group_id = aws_security_group.lb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}

# app-sg

resource "aws_vpc_security_group_ingress_rule" "app_tomcat" {
  security_group_id = aws_security_group.app.id

  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.lb.id
}

# For test - app-sg

resource "aws_vpc_security_group_ingress_rule" "app_tomcat1" {
  security_group_id = aws_security_group.app.id

  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh" {
  security_group_id = aws_security_group.app.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# backend

resource "aws_vpc_security_group_ingress_rule" "backend_mysql" {
  security_group_id = aws_security_group.backend.id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_ingress_rule" "backend_memcached" {
  security_group_id = aws_security_group.backend.id

  from_port                    = 11211
  to_port                      = 11211
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_ingress_rule" "backend_rabbitmq" {
  security_group_id = aws_security_group.backend.id

  from_port                    = 5672
  to_port                      = 5672
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
  security_group_id = aws_security_group.backend.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


# Allow backend_self
resource "aws_vpc_security_group_ingress_rule" "backend_self" {
  security_group_id = aws_security_group.backend.id

  ip_protocol = "-1"
  referenced_security_group_id = aws_security_group.backend.id
}


# LB outbound
resource "aws_vpc_security_group_egress_rule" "lb_all" {
  security_group_id = aws_security_group.lb.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# App outbound
resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# Backend outbound
resource "aws_vpc_security_group_egress_rule" "backend_all" {
  security_group_id = aws_security_group.backend.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}