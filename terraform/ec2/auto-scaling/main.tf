resource "aws_instance" "webserver-exemplo" {
    ami = "ami-1234"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, world" > index.html
        nohub busybox httpd -f -p ${var.server_port} &
        EOF

    user_data_replace_on_change = true

    tags = {
        Name = "webserver-autoscaling"
    }
}

resource "aws_security_group" "instance" {
    name = "webserver-exemplo-instance"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}