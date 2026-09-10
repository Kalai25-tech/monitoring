output "lb_sg_id" {
  description = "Security group ID for the load balancer"
  value       = aws_security_group.lb.id
}

output "app_sg_id" {
  description = "Security group ID for the app tier"
  value       = aws_security_group.app.id
}

output "backend_sg_id" {
  description = "Security group ID for the backend tier"
  value       = aws_security_group.backend.id
}