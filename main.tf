provider "aws" {
  region = "us-east-1"
}

# Security Group for the EC2 instance
resource "aws_security_group" "app_sg" {
  name        = "app_security_group"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (use with caution)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami           = "ami-12345678" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "MyAppInstance"
  }
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "my-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_sg.id]
  subnets            = ["subnet-12345678", "subnet-87654321"] # Replace with valid subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "MyAppLoadBalancer"
  }
}

# Load Balancer Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "my-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678" # Replace with a valid VPC ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}
