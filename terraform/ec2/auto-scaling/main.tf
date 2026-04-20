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

    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

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
    security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.exemplo.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found"
        status_code = 404
      }
    }
}

resource "aws_security_group" "alb" {
    name = "terraform-exemplo-alb"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "asg" {
    name = "terraform-asg-exemplo"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
          values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}
