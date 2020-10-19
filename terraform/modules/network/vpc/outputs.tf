output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value       = {for subnet in aws_subnet.private_subnet: subnet.arn => subnet.id}
  depends_on  = [aws_subnet.private_subnet]
}

output "public_subnet_ids" {
  value       = {for subnet in aws_subnet.public_subnet: subnet.arn => subnet.id}
  depends_on  = [aws_subnet.public_subnet]
}
