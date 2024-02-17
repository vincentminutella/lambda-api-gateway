##API Gateway with a single POST route to an SQS queue with a lambda trigger designed to write a todo list item to a dynamodb table

Tested using ThunderClient via the public API invokation URI with an example data structure: 

{
  "id":"1",
  "date":"02162024",
  "text":"test"
}
