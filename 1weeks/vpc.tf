
resource "aws_vpc" "test_vpc" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "test_subnet_public_a" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "172.20.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-public-a"
  }
}

resource "aws_subnet" "test_subnet_public_b" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "172.20.2.0/24"
  availability_zone       = "ap-northeast-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-public-b"
  }
}

resource "aws_subnet" "test_subnet_public_c" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "172.20.3.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-public-c"
  }
}

resource "aws_subnet" "test_subnet_public_d" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "172.20.4.0/24"
  availability_zone       = "ap-northeast-2d" 
  map_public_ip_on_launch = true
  tags = {
    Name = "test-subnet-public-d"
  }
}
