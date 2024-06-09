provider "aws"{
    region = "us-east-2"
}

variable "ami"{
    description = "value"
}
variable "instance_type"{
    description = "value"
    type = map(string)

    default =  {
        "dev"     = "t2.micro"
        "staging" = "t2.medium"
        "prod"    = "t2.xlarge"
    }
}

module "ec2_instance"{
    source        = "./modules/ec2_instance"
    ami           =  var.ami
    instance_type =  lookup(var.instance_type,terraform.workspace,"error")
}


