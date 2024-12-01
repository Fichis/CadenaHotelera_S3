terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

#? Creación de par de claves
resource "aws_key_pair" "ubuntu-ssh" {
  key_name   = "ubuntu-ssh"
  public_key = file("../my-key-pair.pub")

  tags = {
    Name = "CadHotelera" 
  }
}

#? Creación de Instancia EC2
resource "aws_instance" "ubuntu" {
  ami               = "ami-0453ec754f44f9a4a"
  instance_type     = "t2.micro"

  user_data = file("./script.sh")

  key_name = aws_key_pair.ubuntu-ssh.key_name

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }

  tags = {
    Name = "Cadena_Hotelera"
  }
}