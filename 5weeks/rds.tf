resource "aws_db_subnet_group" "subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.db_subnet_priv_a.id,aws_subnet.db_subnet_priv_b.id,aws_subnet.db_subnet_priv_c.id,aws_subnet.db_subnet_priv_d.id]

  tags = {
    Name = "db_subnet_group"
  }
}


resource "aws_security_group" "rds_security_group" {
  name        = "test-db-security-group"
  description = "rds security group"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "mariadb-parameter-group"
  family = "mariadb11.4"
}

resource "aws_db_instance" "db_instance" {
  identifier             = "gun"
  instance_class         = "db.t4g.micro"
  port                   = 3306
  multi_az               = false
  allocated_storage      = 20
  max_allocated_storage  = 1000
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  
  engine_version         = "11.4.5"
  parameter_group_name   = aws_db_parameter_group.parameter_group.name
  apply_immediately     = true
  
  storage_encrypted = false
  
  db_name                = "mydatabase"
  engine                 = "mariadb"
  username               = "admin"
  password               = "Raon1234"
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  
  skip_final_snapshot   = true
  depends_on = [
    aws_nat_gateway.nat
  ]
}

