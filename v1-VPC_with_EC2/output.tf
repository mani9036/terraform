output "public_ip_of__server" {
    description = "this is the public IP"
    value = aws_instance.server.public_ip
}

output "private_ip_of__server" {
    description = "this is the public IP"
    value = aws_instance.server.private_ip
}