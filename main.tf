provider "aws" {
  region = "us-west-2"
}

provider "random" {}

resource "random_pet" "name" {}

resource "aws_instance" "web" {
  ami           = "ami-a0cfeed8"
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")
  #  security_groups = [aws_security_group.web-sg.id]
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  tags = {
    Name = random_pet.name.id
  }
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.name.id}-sg"
  #  description = "Allow TLS inbound traffic"
  #  vpc_id      = aws_vpc.something.id 

  ingress {
    #    description = "HTTP rule"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = random_pet.name.id
  }
}


