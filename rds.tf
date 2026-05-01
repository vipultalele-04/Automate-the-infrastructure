# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet" {
  name = "db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id
  ]

  tags = {
    Name = "db-subnet-group"
  }
}

# Primary Database
resource "aws_db_instance" "db" {
  identifier            = "primary-mysql-db"   # ✅ MUST be fixed
  allocated_storage     = 20
  engine                = "mysql"
  instance_class        = "db.t3.micro"
  username              = "admin"
  password              = "password123"

  db_subnet_group_name  = aws_db_subnet_group.db_subnet.name
  multi_az              = true

 backup_retention_period = 7


  skip_final_snapshot   = true

  tags = {
    Name = "primary-db"
  }
}
# Read Replica
resource "aws_db_instance" "read_replica" {
  identifier           = "mysql-read-replica"
  replicate_source_db  = aws_db_instance.db.identifier
  instance_class       = "db.t3.micro"

  depends_on = [aws_db_instance.db]

  tags = {
    Name = "read-replica-db"
  }
}
