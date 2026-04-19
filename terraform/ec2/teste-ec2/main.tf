provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example2" {
    ami = "ami-1234"
    instance_type = "t2.micro"

    tags = {
        Name = "exemplo2-terraform"
    }
}