# Tomcat

output "tomcat_public_ip" {
  description = "Public IP of the Tomcat app server"
  value       = module.tomcat.public_ip
}

output "tomcat_instance_id" {
  description = "Instance ID of the Tomcat app server"
  value       = module.tomcat.instance_id
}

# Mysql

output "mysql_public_ip" {
  description = "Public IP of the Tomcat app server"
  value       = module.mysql.public_ip
}

output "mysql_instance_id" {
  description = "Instance ID of the Tomcat app server"
  value       = module.mysql.instance_id
}

# Rabbitmq

output "rabbitmq_public_ip" {
  description = "Public IP of the Tomcat app server"
  value       = module.rabbitmq.public_ip
}

output "rabbitmq_instance_id" {
  description = "Instance ID of the Tomcat app server"
  value       = module.rabbitmq.instance_id
}

# Memcached

output "memcache_public_ip" {
  description = "Public IP of the Tomcat app server"
  value       = module.memcache.public_ip
}

output "memcache_instance_id" {
  description = "Instance ID of the Tomcat app server"
  value       = module.memcache.instance_id
}


output "s3_bucket_id" {
  description = "The name of the S3 bucket for WAR artifacts"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket for WAR artifacts"
  value       = module.s3.bucket_arn
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB - use this to access the app"
  value       = module.alb.alb_dns_name
}
