resource "aws_alb" "public-alb" {
    
    name            = "public-alb"
    internal        = false
    security_groups = [aws_security_group.iti-public-sg.id]
    subnets = [aws_subnet.iti-subnet-public-1.id,aws_subnet.iti-subnet-public-2.id]
    tags = {
        name = "public-alb"
    }
}


resource "aws_alb_target_group" "private-tg-1" {
    
    port = 8081
    protocol = "HTTP"
    vpc_id = aws_vpc.iti-vpc.id
    tags = {
        name = "private-tg-1"
    }
}




resource "aws_alb_listener" "private-alb-listener-1" {
    load_balancer_arn = aws_alb.public-alb.arn
    port              = "8081"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.private-tg-1.arn
        type             = "forward"
    }
}

resource "aws_alb_target_group" "private-tg-2" {
    
    port = 9000
    protocol = "HTTP"
    vpc_id = aws_vpc.iti-vpc.id
    tags = {
        name = "private-tg-2"
    }
}




resource "aws_alb_listener" "private-alb-listener-2" {
    load_balancer_arn = aws_alb.public-alb.arn
    port              = "9000"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.private-tg-2.arn
        type             = "forward"
    }
}