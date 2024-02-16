resource "aws_sqs_queue" "queue" {
  name                      = "api-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_queue.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue" "deadletter_queue" {
  name = "api-deadletter_queue"
  message_retention_seconds = 1209600
}