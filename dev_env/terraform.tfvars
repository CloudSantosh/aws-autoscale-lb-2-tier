region                  = "us-east-2"
project_name            = "AWS-ReStart-auto-scaling"
vpc_cidr                = "192.168.0.0/16"
public_subnet_az1_cidr  = "192.168.0.0/24"
public_subnet_az2_cidr  = "192.168.1.0/24"
private_subnet_az1_cidr = "192.168.2.0/24"
private_subnet_az2_cidr = "192.168.3.0/24"
max_size                = 5
min_size                = 2
instance_type           = "t2.micro"