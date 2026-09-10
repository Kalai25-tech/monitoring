output "grafana" {
  description = "Security group ID for the load balancer"
  value       = aws_security_group.grafana.id
}

output "prometheus" {
  description = "Security group ID for the app tier"
  value       = aws_security_group.prometheus.id
}