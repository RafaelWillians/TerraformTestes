provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "webserver" {
    ami = "ami-1234"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, world" > index.html
        nohub busybox httpd -f -p 8080 &
        EOF
    
    user_data_replace_on_change = true

    tags = {
        Name = "webserver-exemplo"
    }
}

resource "aws_security_group" "instance" {
    name = "webserver-exemplo-instance"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}