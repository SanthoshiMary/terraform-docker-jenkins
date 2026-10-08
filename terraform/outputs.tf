output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_1_id" {
  value = aws_subnet.public_1.id
}

output "subnet_2_id" {
  value = aws_subnet.public_2.id
}

output "ec2_1_public_ip" {
  value = aws_instance.docker_1.public_ip
}

output "ec2_2_public_ip" {
  value = aws_instance.docker_2.public_ip
}

output "ec2_1_public_dns" {
  value = aws_instance.docker_1.public_dns
}

output "ec2_2_public_dns" {
  value = aws_instance.docker_2.public_dns
}