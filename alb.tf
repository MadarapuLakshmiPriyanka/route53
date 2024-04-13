resource "aws_lb_target_group" "albtg" {
    vpc_id = aws_vpc.dev.id
    name = "priyatg"
    protocol = "HTTP"
    port =80
    health_check {
    enabled             = true
    port                = 80
    interval            = 30
    protocol            = "HTTP"
    path                = "/index.html"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    }
    tags = {
        Name = "${var.vpc_name}-alb"
    }
  
}

resource "aws_lb_target_group_attachment" "albattach1" {
    target_group_arn = aws_lb_target_group.albtg.arn
    target_id = aws_instance.server1.id
  
}
resource "aws_lb_target_group_attachment" "albattach2" {
    target_group_arn = aws_lb_target_group.albtg.arn
    target_id = aws_instance.server2.id
  
}
resource "aws_lb_target_group_attachment" "albattach3" {
    target_group_arn = aws_lb_target_group.albtg.arn
    target_id = aws_instance.server3.id
  
}
resource "aws_lb" "applicationloadbalancer" {
    load_balancer_type = "application"
    name = "priyaalb"
    internal = false
    security_groups = [aws_security_group.sg.id]
    subnets = [aws_subnet.publicsubnet[0].id,aws_subnet.publicsubnet[1].id,aws_subnet.publicsubnet[2].id]
    
  
}

resource "aws_lb_listener" "alblisten" {
    load_balancer_arn = aws_lb.applicationloadbalancer.arn
    protocol = "HTTPS"
    port = 443
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.albtg.arn
    }
    certificate_arn = aws_acm_certificate.certificate.arn
}