

resource "aws_subnet" "default2" {

  vpc_id = aws_vpc.default.id

  cidr_block = "10.0.2.0/24"

  #map_public_ip_on_launch = true

}


# A security group for the nginx so it is accessible via the web

resource "aws_security_group" "jenks" {

  name = "jenkins-connect"

  description = " jenkin machine "

  vpc_id = aws_vpc.default.id

  #  Access via the internet

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





data "template_file" "myuserdata2" {

  template = file("${path.cwd}/temp_jenks.tpl")

  }

resource "aws_instance" "jenkins" {

  instance_type = "t2.micro"

  ami = var.amis[var.aws_region]

  key_name = "tkay"

  # Our Security group to allow HTTP and SSH access

  vpc_security_group_ids = [aws_security_group.jenks.id]

  subnet_id = aws_subnet.default2.id 

  user_data = data.template_file.myuserdata2.template

  tags = {

    Name = "Jenkins_Server"

  }


}

  resource "aws_eip" "jenk" {
  instance = aws_instance.jenkins.id
  vpc      = true
}
