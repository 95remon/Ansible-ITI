data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}


resource "aws_instance" "jumb-host" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = "ansible"
    vpc_security_group_ids = [aws_security_group.iti-public-sg.id]
    subnet_id = aws_subnet.iti-subnet-public-2.id
    associate_public_ip_address = true
    tags = {
        Name = "jumb-host"
    }
}


resource "aws_instance" "sonarqube" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.medium"
    key_name = "ansible"
    vpc_security_group_ids = [aws_security_group.iti-public-sg.id]
    subnet_id = aws_subnet.iti-subnet-private-1.id
    associate_public_ip_address = false
    tags = {
        Name = "sonarqube"
    }
}


resource "aws_instance" "nexus" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.medium"
    key_name = "ansible"
    vpc_security_group_ids = [aws_security_group.iti-public-sg.id]
    subnet_id = aws_subnet.iti-subnet-private-2.id
    associate_public_ip_address = false
    tags = {
        Name = "nexus"
    }
}

resource "aws_alb_target_group_attachment" "private-target-group-attachment1" {
  target_group_arn = aws_alb_target_group.private-tg-1.arn
  target_id = aws_instance.nexus.id
  port = 8081
}

resource "aws_alb_target_group_attachment" "private-target-group-attachment2" {
  target_group_arn = aws_alb_target_group.private-tg-2.arn
  target_id = aws_instance.sonarqube.id
  port = 9000
}