output "public_ip" {
    value = aws_instance.webserver-exemplo.public_ip
    description = "Endereco publico do servidor web"
}