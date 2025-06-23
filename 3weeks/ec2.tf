resource "aws_security_group" "any" {
  name        = "any"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "any"
  }
}

resource "aws_instance" "priv" {
  ami                         = "ami-0c593c3690c32e925" 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test_subnet_priv_a.id
  vpc_security_group_ids      = [aws_security_group.any.id]
  associate_public_ip_address = false

  credit_specification {
    cpu_credits = "standard"  
  }

  tags = {
    Name = "priv"
  }
}

resource "aws_instance" "pub" {
  ami                         = "ami-0c593c3690c32e925" 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test_subnet_public_a.id
  vpc_security_group_ids      = [aws_security_group.any.id]
  associate_public_ip_address = true

  credit_specification {
    cpu_credits = "standard"  
  }

  tags = {
    Name = "pub"
  }
}

