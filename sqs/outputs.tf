output "sqs_arn" {
    value = aws_sqs_queue.queue.arn
}

output "sqs_name" {
    value = aws_sqs_queue.queue.name
}