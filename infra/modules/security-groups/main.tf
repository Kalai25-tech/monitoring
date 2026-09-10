resource "aws_security_group" "grafana" {
  name   = "grafana-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "grafana-sg"
  }
}

resource "aws_security_group" "prometheus" {
  name   = "prometheus-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "prometheus-sg"
  }
}


# grafana

resource "aws_vpc_security_group_ingress_rule" "grafana_console" {
  security_group_id = aws_security_group.grafana.id

  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "grafana_ssh" {
  security_group_id = aws_security_group.grafana.id

  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

# prometheus

resource "aws_vpc_security_group_ingress_rule" "prometheus_ssh" {
  security_group_id = aws_security_group.prometheus.id

  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "prometheus_console_from_public" {
  security_group_id = aws_security_group.prometheus.id

  from_port   = 9090
  to_port     = 9090
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_ingress_rule" "prometheus_console_from_grafana" {
  security_group_id = aws_security_group.prometheus.id

  from_port                    = 9090
  to_port                      = 9090
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.grafana.id
}


# grafana outbound
resource "aws_vpc_security_group_egress_rule" "grafana_outbound" {
  security_group_id = aws_security_group.grafana.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# prometheus outbound
resource "aws_vpc_security_group_egress_rule" "prometheus_outbound" {
  security_group_id = aws_security_group.prometheus.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}