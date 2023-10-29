resource "aws_vpc" "ec2_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "ec2_vpc"
  }
}

resource "aws_subnet" "ec2_subnet" {
  vpc_id                  = aws_vpc.ec2_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "ec2_subnet"
  }
}

resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = aws_vpc.ec2_vpc.id
  tags = {
    Name = "ec2_igw"
  }

}


resource "aws_route_table" "ec2_rt" {

  vpc_id = aws_vpc.ec2_vpc.id
  tags = {
    Name = "ec2_rt"
  }
}


resource "aws_route" "ec2_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.ec2_rt.id
  gateway_id             = aws_internet_gateway.ec2_igw.id

}

resource "aws_route_table_association" "ec2_route_associations" {
  route_table_id = aws_route_table.ec2_rt.id
  subnet_id      = aws_subnet.ec2_subnet.id

}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2_sg"
  vpc_id = aws_vpc.ec2_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["45.64.161.190/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "ec2_keypair" {
  key_name   = "ec2_keypair"
  public_key = file("~/.ssh/learnterra_ssh.pub")

}

resource "aws_instance" "ec2_instances" {
  ami                    = data.aws_ami.ubunut.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.ec2_subnet.id
  key_name               = aws_key_pair.ec2_keypair.key_name
  user_data              = file("userdata.tpl")
  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "Ec2"
  }
}


