# This is for getting latest ubuntu image from AWS
data "aws_ami" "os_image" {
    owners = ["099720109477"]
    most_recent = true

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/*24.04-amd64*"]
    }
}

# Key-Pair

resource "aws_key_pair" "key" {
  key_name = "terraform-key"
  public_key = file("terraform-key.pub")
}

resource "aws_default_vpc" "default" {
  
}


resource "aws_security_group" "allow_users_to_connect" {
    name = "terrraform-sg"
    description = "ALLOW USERS TO CONNECT"
    vpc_id = aws_default_vpc.default.id

    ingress {
        description = "ALLOW port 22"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "ALLOW OUTGOING TRAFFIC"
        from_port = 0
        to_port = 0
        protocol = "-1" # Means all protocols
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow port 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow port 443"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        name = "easy_app_SG"
    }
}

resource "aws_instance" "easy-shop" {
    ami = data.aws_ami.os_image.id
    instance_type = var.instance_type
    key_name = aws_key_pair.key.key_name
    security_groups = [aws_security_group.allow_users_to_connect.name]
    user_data = file("${path.module}/install_tools.sh")
    tags = {
        name = "Easy-Shop"
    }
}