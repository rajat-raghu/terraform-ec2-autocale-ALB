provider "aws"{
    region = "ap-south-1"
    profile= "amogh"
}
# Launch configuration

resource "aws_launch_configuration" "launchconfig" {
  name          = "${var.app_name}-lc"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data         = "${file("LAMP.sh")}"

   root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    }
}

resource "aws_autoscaling_group" "tf-asg" {
  name                      = "${var.app_name}-as"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launchconfig.name
  target_group_arns         = [aws_lb_target_group.tg.arn]
  vpc_zone_identifier       = [aws_subnet.private-1.id]
 # target_group_arns         = aws_lb_target_group.tg-1.arn
}

# Target group for ELB
resource "aws_lb_target_group" "tg" {
  name     = "tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  tags = {
    Name = "${var.app_name}-alb"
    tier = "dev"
  }
}

# Application load balancer resource
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.app_name}"
  }
}

# Listener 
resource "aws_lb_listener" "listener-80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
