output "grafana_sg_id" {
  description = "Security group ID for the grafana"
  value       = aws_security_group.grafana.id
}

output "prometheus_sg_id" {
  description = "Security group ID for the prometheus"
  value       = aws_security_group.prometheus.id
}

output "loki_sg_id" {
  description = "Security group ID for the loki"
  value       = aws_security_group.loki.id
}
