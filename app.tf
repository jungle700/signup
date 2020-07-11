# Specify the provider and access details

provider "aws" {

  region = var.aws_region

}

resource "aws_vpc" "default" {

  cidr_block = "10.0.0.0/16"

}


resource "aws_internet_gateway" "default" {

  vpc_id = aws_vpc.default.id

}


resource "aws_route" "internet_access" {

  route_table_id = aws_vpc.default.main_route_table_id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.default.id

}



resource "aws_subnet" "default1" {

  vpc_id = aws_vpc.default.id

  cidr_block = "10.0.1.0/24"

  #map_public_ip_on_launch = true

}


# A security group for the nginx so it is accessible via the web

resource "aws_security_group" "app" {

  name = "app-connect"

  description = " app machine "

  vpc_id = aws_vpc.default.id

  #  Access via the internet

  ingress {

    from_port = 5000

    to_port = 5000

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  # Jenkins Pipeline

  ingress {

    from_port = 8080

    to_port = 8080

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  # Access via SSH

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  # outbound internet access

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}








resource "aws_key_pair" "tkay" {

  key_name = "tkay"

  public_key = file(var.path_to_public_key)

}

data "template_file" "myuserdata1" {

  template = file("${path.cwd}/temp_app.tpl")

}

resource "aws_instance" "app" {

  instance_type = "t2.micro"

  ami = var.amis[var.aws_region]

  key_name = "tkay"

  # Our Security group to allow HTTP and SSH access

  vpc_security_group_ids = [aws_security_group.app.id]

  subnet_id = aws_subnet.default1.id

  user_data = data.template_file.myuserdata1.template

  tags = {

    Name = "App_Server"

  }

}

resource "aws_eip" "main2" {
  instance = aws_instance.app.id
  vpc      = true
}


resource "aws_dynamodb_table" "sig-db" {
  name           = "sig-db"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "name"
  range_key      = "email"

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  tags = {
    Name        = "sig-db"
    Environment = "dev"
  }
}


# resource "aws_sns_topic" "user_updates" {
#   name = "user-updates-topic"
# }



# {
#   "http": {
#     "defaultHealthyRetryPolicy": {
#       "minDelayTarget": 20,
#       "maxDelayTarget": 20,
#       "numRetries": 3,
#       "numMaxDelayRetries": 0,
#       "numNoDelayRetries": 0,
#       "numMinDelayRetries": 0,
#       "backoffFunction": "linear"
#     },
#     "disableSubscriptionOverrides": false
#   }
# }