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

resource "aws_launch_configuration" "exemplo" {
    image_id = "ami-1234"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.id]

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, world" > index.html
        nohub busybox httpd -f -p ${var.server_port} &
        EOF

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "exemplo" {
    launch_configuration = aws_launch_configuration.exemplo.name
    vpc_zone_identifier = data.aws_subnets.default.ids

    min_size = 3
    max_size = 10

    tag {
        key = "Name"
        value = "terraform-asg-exemplo"
        propagate_at_launch = true      
    }
}

resource "aws_lb" "exemplo" {
    name = "terraform-asg-exemplo"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
}