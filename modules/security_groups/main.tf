#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create security group for the application load balancer
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "alb_security_group" {
  name        = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "application-loadbalancer-security-group "
  }
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create security group for the public ec2 instance
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "public_ec2_security_group" {
  name        = "public ec2 instance security group"
  description = "enable http/https access on port 80/443 via ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    //cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    //  cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.alb_security_group.id]

  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-ec2-security-group"
  }
}



#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create security group for the private RDS instance
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "rds_security_group" {
  name   = "RDS security Group"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

