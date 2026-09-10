# grafana

output "grafana_public_ip" {
  description = "Public IP of the Tomcat app server"
  value       = module.grafana.public_ip
}

output "grafana_instance_id" {
  description = "Instance ID of the Tomcat app server"
  value       = module.grafana.instance_id
}

# prometheus

output "prometheus_public_ip" {
  description = "Public IP of the Tomcat app server"
  value       = module.prometheus.public_ip
}

output "prometheus_instance_id" {
  description = "Instance ID of the Tomcat app server"
  value       = module.prometheus.instance_id
}
