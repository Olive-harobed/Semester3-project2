resource "aws_alb" "alb" {
  name = var.alb_name
  internal        = false
  security_groups = [var.alb_security_group]
  subnets         = data.aws_subnets.public_subnets.ids
}

resource "aws_alb_target_group" "alb_tg" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.demo_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    path                = "/"
  }
}


resource "aws_alb_listener" "mini-listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }
}

resource "aws_alb_target_group_attachment" "demo_tgs" {
  count  = length(aws_instance.ec2_instances.*.id)
  target_group_arn = aws_alb_target_group.alb_tg.arn
  target_id        = aws_instance.ec2_instances.*.id[count.index]
}



