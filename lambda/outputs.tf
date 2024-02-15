output "lambda_arn" {
    description = "output of the default lambda handler" 
    value = aws_lambda_function.lambda.arn
}