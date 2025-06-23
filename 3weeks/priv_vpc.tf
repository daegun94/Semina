resource "aws_subnet" "test_subnet_priv_a" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.100.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "test_subnet_priv_a"
  }
}

resource "aws_subnet" "test_subnet_priv_b" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.101.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "test_subnet_priv_b"
  }
}

resource "aws_subnet" "test_subnet_priv_c" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.102.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "test_subnet_priv_c"
  }
}

resource "aws_subnet" "test_subnet_priv_d" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "172.20.103.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "test_subnet_priv_d"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "test_nat_eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.test_subnet_public_a.id

  tags = {
    Name = "test_nat_gateway"
  }

  depends_on = [aws_eip.nat_eip]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test-vpc-private-rtb"
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "test_priv_rtb_assoc_a" {
  subnet_id      = aws_subnet.test_subnet_priv_a.id
  route_table_id = aws_route_table.test_private_rt.id
}

