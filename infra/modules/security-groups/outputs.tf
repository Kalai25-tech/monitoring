output "grafana_sg_id" {
  description = "Security group ID for the load balancer"
  value       = aws_security_group.grafana.id
}

output "prometheus_sg_id" {
  description = "Security group ID for the app tier"
  value       = aws_security_group.prometheus.id
}

