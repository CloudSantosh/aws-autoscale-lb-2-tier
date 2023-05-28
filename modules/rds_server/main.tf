resource "aws_db_instance" "rds_server_backend" {
  allocated_storage      = 10
  db_name                = "awsrestartdb123"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = "awsrestart"
  password               = "Awsrestart1234"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = "db_sub_group"
  vpc_security_group_ids = [var.rds_security_group_id]
  skip_final_snapshot    = true

}

#create rds instance subnet group
resource "aws_db_subnet_group" "db_sub_group" {
  name       = "db_sub_group"
  subnet_ids = [var.private_subnet_az1_id, var.private_subnet_az2_id]
}
