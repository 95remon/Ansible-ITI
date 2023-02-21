# create Main VPC ----------------------------------------------------

resource "aws_vpc" "iti-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "iti-vpc-10.0.0.0/16"
  }
}

# create 4 subnets (2 public and 2 private) --------------------------

resource "aws_subnet" "iti-subnet-public-1" {
  vpc_id = aws_vpc.iti-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

  tags = {
        Name = "iti-subnet-public-1"
  }

}

resource "aws_subnet" "iti-subnet-public-2" {
  vpc_id = aws_vpc.iti-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true 

  tags = {
        Name = "iti-subnet-public-2"
  }

}


resource "aws_subnet" "iti-subnet-private-1" {
  vpc_id = aws_vpc.iti-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
        Name = "iti-subnet-private-1"
  }

}


resource "aws_subnet" "iti-subnet-private-2" {
  vpc_id = aws_vpc.iti-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
        Name = "iti-subnet-private-2"
  }

}

# Create Internet GW and Nat GW ---------------------------------------

resource "aws_internet_gateway" "iti-gw" {
  vpc_id = aws_vpc.iti-vpc.id

  tags = {
    Name = "iti-main-gw"
  }
}

resource "aws_eip" "iti-eip" {
    vpc              = true
}

resource "aws_nat_gateway" "iti-nat-gw" {
    allocation_id = aws_eip.iti-eip.id
    subnet_id     = aws_subnet.iti-subnet-public-1.id

    tags = {
        Name = "iti-nat-gw"
    }
}

# create public route table ----------------------------------------------

resource "aws_route_table" "iti-public-rt" {
  vpc_id = aws_vpc.iti-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iti-gw.id
  }

  tags = {
    Name = "iti-public-rt"
  }
}

# create private route table  -----------------------------------------

resource "aws_route_table" "iti-private-rt" {
  vpc_id = aws_vpc.iti-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.iti-nat-gw.id
  }

  tags = {
    Name = "iti-private-rt"
  }
}

# route table association -----------------------------------------------

resource "aws_route_table_association" "iti-public1-rta" {

  subnet_id      = aws_subnet.iti-subnet-public-1.id
  route_table_id = aws_route_table.iti-public-rt.id

}

resource "aws_route_table_association" "iti-public2-rta" {

  subnet_id      = aws_subnet.iti-subnet-public-2.id
  route_table_id = aws_route_table.iti-public-rt.id

}

resource "aws_route_table_association" "iti-private1-rta" {

  subnet_id      = aws_subnet.iti-subnet-private-1.id
  route_table_id = aws_route_table.iti-private-rt.id

}

resource "aws_route_table_association" "iti-private2-rta" {

  subnet_id      = aws_subnet.iti-subnet-private-2.id
  route_table_id = aws_route_table.iti-private-rt.id

}


# security group ------------------------------------------------------

resource "aws_security_group" "iti-public-sg" {
    
    vpc_id      = aws_vpc.iti-vpc.id

    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }


    ingress {
        from_port        = 8081
        to_port          = 8081
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }



    ingress {
        from_port        = 9000
        to_port          = 9000
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }




    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "iti-public-sg"
        description = "iti-public-sg"
    }
}

