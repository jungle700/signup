


# terraform {
#   backend "s3" {
#     bucket = "my-tf-dev001"
#     key    = "signup/terraform.tfstate"
#     region = "eu-west-1"
#   }
# }

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "my-tf-dev001"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "eu-west-1"
    key            = "signup/terraform.tfstate"
  }
}

# resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
#   name           = "terraform-state-lock-dynamo"
#   hash_key       = "LockID"
#   read_capacity  = 5
#   write_capacity = 5

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "DynamoDB Terraform State Lock Table"
#   }
# }

