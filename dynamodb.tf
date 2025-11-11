resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "ton-app"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "pk"
  range_key      = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "gsi1pk"
    type = "S"
  }

  attribute {
    name = "gsi1sk"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name               = "gsi1pk-gsi1sk-index"
    hash_key           = "gsi1pk"
    range_key          = "gsi1sk"
    projection_type    = "ALL"
    read_capacity      = 5
    write_capacity     = 5
  }
}
