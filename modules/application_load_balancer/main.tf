#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create Application load balancer
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_lb" "application_load_balancer" {
  name                       = "${var.project_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  security_groups            = [var.alb_security_group]
  enable_deletion_protection = false

  tags = {
    name = "${var.project_name}-application-loadbalancer"
  }

}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create target Group
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "application_lb_target_group" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create Listener
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_lb_listener" "application_load_balancer_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_lb_target_group.arn
  }

}



