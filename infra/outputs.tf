# grafana

output "grafana_public_ip" {
  description = "Public IP of the grafana server"
  value       = module.grafana.public_ip
}

output "grafana_private_ip" {
  description = "private_ip IP of the grafana server"
  value       = module.grafana.private_ip
}

output "grafana_instance_id" {
  description = "Instance ID of the grafana server"
  value       = module.grafana.instance_id
}

# prometheus

output "prometheus_public_ip" {
  description = "Public IP of the prometheus server"
  value       = module.prometheus.public_ip
}

output "prometheus_private_ip" {
  description = "private_ip of the prometheus server"
  value       = module.prometheus.private_ip
}


output "prometheus_instance_id" {
  description = "Instance ID of the prometheus server"
  value       = module.prometheus.instance_id
}
