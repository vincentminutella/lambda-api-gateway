API Gateway with a single POST route to an SQS queue with a lambda trigger designed to write a todo list item to a dynamodb table

All service infrastructure including gateway, queue, lambda, and db table are validated to be successfully integrated, but I am having issues with the middleware function in the lambda successfully writing to the db table.
