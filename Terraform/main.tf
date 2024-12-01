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
resource "aws_key_pair" "fedora-ssh" {
  key_name   = "fedora-ssh"
  public_key = file("../my-key-pair.pub")

  tags = {
    Name = "CadHotelera" 
  }
}

#? Creación de Instancia EC2
resource "aws_instance" "fedora" {
  ami               = "ami-0453ec754f44f9a4a"
  instance_type     = "t2.micro"

  user_data = file("./script.sh")

  key_name = aws_key_pair.fedora-ssh.key_name

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }

  tags = {
    Name = "Cadena_Hotelera"
  }
}

output "instance_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.fedora.public_ip
}