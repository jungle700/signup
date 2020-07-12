output "instance_ips" {
  value = aws_instance.app.*.public_ip
}

output "dynamo_Sign" {
    value = aws_dynamodb_table.sig-db.id
}