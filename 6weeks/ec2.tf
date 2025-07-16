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

resource "aws_iam_role_policy_attachment" "s3_full_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name_prefix = "ssm_instance_profile_"
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

  user_data = base64encode(local.priv_bootstrap_script)
  
  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  depends_on = [
    aws_nat_gateway.nat
  ]
  
}

resource "aws_instance" "pub" {
  ami                         = "ami-0c593c3690c32e925" 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.test_subnet_public_a.id
  vpc_security_group_ids      = [aws_security_group.any.id]
  associate_public_ip_address = true

  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name

  credit_specification {
    cpu_credits = "standard"  
  }

  tags = {
    Name = "pub"
  }

  user_data = base64encode(local.pub_bootstrap_script)
  
  lifecycle {
    ignore_changes = [
      user_data
    ]
  }

  depends_on = [
    aws_nat_gateway.nat
  ]

}

locals {
  pub_bootstrap_script = <<EOF
#!/bin/bash -l
set -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 
yum install nginx -y
aws s3 cp s3://gun-semina/nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx
systemctl enable nginx
EOF
}

locals {
  priv_bootstrap_script = <<EOF
#!/bin/bash -l
set -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 
yum install -y java-17-amazon-corretto
aws s3 cp s3://gun-semina/test.jar ./test.jar
aws s3 cp s3://gun-semina/application.yaml ./application.yaml
java -jar test.jar --spring.config.location=file:./application.yaml
EOF
}


