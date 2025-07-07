resource "aws_subnet" "db_subnet_priv_a" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.5.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "test_dbsubnet_priv_a"
  }
}

resource "aws_subnet" "db_subnet_priv_b" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.6.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "test_dbsubnet_priv_b"
  }
}

resource "aws_subnet" "db_subnet_priv_c" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.7.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "test_dbsubnet_priv_c"
  }
}

resource "aws_subnet" "db_subnet_priv_d" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.8.0/24"
  availability_zone = "ap-northeast-2d"

  tags = {
    Name = "test_dbsubnet_priv_d"
  }
}