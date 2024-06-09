provider "aws" {
    region = "us-east-2"
}

variable "ami" {
    description = "my ami id"
}

variable "instance_type"{
    description = "this instance is of ubuntu machine"
}

resource "aws_instance" "nano" {
    ami = var.ami
    instance_type = var.instance_type
}
