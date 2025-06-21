output "alb_dns_name" {
  value       = module.ecs.alb_dns_name
  description = "DNS name of the ECS load balancer"
}
