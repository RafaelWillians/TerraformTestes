output "public_ip" {
    value = coalesce(aws_instance.webserver-exemplo.public_ip, "IP nao disponivel")
    description = "Endereco publico do servidor web"
}