provider "aws" {
    region = "us-east-2"
}

variable "ami" {
    description = "this is the ami id for the ubuntu image"
}

variable "instance_type"{
    description = "this is the t2.micro image"

}

resource "aws_key_pair" "test"{
    key_name = "akash-key"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "webSg" {

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "test"{
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.test.key_name
    vpc_security_group_ids = [aws_security_group.webSg.id]
    
 connection {
    type = "ssh"
    user =  "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip

 }
   provisioner "file" {
    source = "app.py"
    destination = "/home/ubuntu/app.py"
   }

   provisioner "remote-exec" {
    inline = [
         "echo'hello from the remote instance'",
         "sudo apt update -y",
         "sudo apt install apache2 -y",
         "sudo sh -c 'echo \"hello world\" > /var/www/html/index.html'",
    ]
    }
   }
