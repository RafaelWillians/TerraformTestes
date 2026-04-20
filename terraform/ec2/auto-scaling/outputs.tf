output "public_ip" {
    value = coalesce(aws_lb.exemplo.dns_name, "DNS do load balancer nao disponivel")
    description = "Endereco DNS do loadbalancer"
}