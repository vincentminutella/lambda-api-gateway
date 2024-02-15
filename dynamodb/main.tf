
resource "aws_dynamodb_table" "ToDoList" {
  name           = "ToDoList"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "Date"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "Text"
    type = "S"
  }

  global_secondary_index {
    name = "TextIndex"
    hash_key = "Text"
    range_key = "Date"
    write_capacity = 20
    read_capacity = 20 
    projection_type = "INCLUDE"
    non_key_attributes = ["UserId"]
  }
}