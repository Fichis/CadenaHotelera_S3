#? Create a VPC
resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "CadHotel-VPC"
  }
}

#? Creación de la subred pública
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.mi_vpc.id
  cidr_block = "10.0.101.0/24"
  map_public_ip_on_launch = true #Mapea una ip pública al crearse

  # Poner un tag, para encontrar rápidamente cuál ha creado
  tags = {
    Name = "Public-DAW"
  }
}

#? Creación del Internet Gateway
resource "aws_internet_gateway" "cadhotel-gw" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "cadhotel-gw"
  }
}

#? Creación de la tabla de enrutamiento pública
resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.mi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cadhotel-gw.id
  }

  tags = {
    Name = "rt-public-cadhotel"
  }
}

#? Asociación de la tabla de enrutamiento
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt-public.id
}

#? Creación del grupo de seguridad
resource "aws_security_group" "cadhotel-sg" {
  name        = "cad-hotel-sg"
  description = "Permitir SSH y HTTP"
  vpc_id      = aws_vpc.mi_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh&http"
  }
}

#? Asociaciones de subred y grupo de seguridad
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.public_subnet.id
  private_ips     = ["10.0.101.20"]
  security_groups = [aws_security_group.cadhotel-sg.id]
}