resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}


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

  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name

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

