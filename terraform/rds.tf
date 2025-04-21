resource "aws_db_subnet_group" "subnet_group" {
  name       = "fuelmaxpro-db-subnet-group1"
  subnet_ids = aws_subnet.db[*].id

  tags = {
    Name = "fuelmaxpro-db-subnet-group1"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = "fuelmaxpro-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  username                = local.db_creds.name
  password                = local.db_creds.password

  db_subnet_group_name    = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = true
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name = "fuelmaxpro-db"
  }
}
