resource "aws_instance" "ec2" {
     ami = var.ami
     instance_type = var.instance_type
     key_name = var.key_name
     subnet_id = aws_subnet.subnet.id
     associate_public_ip_address = true
     tags = {
       Name = "ec2vpc" 
    }
 }