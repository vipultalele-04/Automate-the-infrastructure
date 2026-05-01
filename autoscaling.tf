# Launch Template
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-template"
  image_id      = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # ✅ Correct way to tag EC2 instances
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "app-server"
      Environment = "Dev"
      Project     = "Terraform"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 2

  vpc_zone_identifier = [
    aws_subnet.private_app_1.id,
    aws_subnet.private_app_2.id
  ]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  # ✅ Correct tag block (THIS is where your error was)
  tag {
  key   = "Name"
  value = "app-server"
  propagate_at_launch = true
}

  tag {
    key                 = "Environment"
    value               = "Dev"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "Terraform"
    propagate_at_launch = true
  }
}
