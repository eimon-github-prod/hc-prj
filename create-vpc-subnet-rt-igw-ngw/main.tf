resource "aws_vpc" "main" {
  cidr_block       = "10.10.0.0/16"

  tags = {
    Name = "master-prod-vpc"
  }
}

################################################################################
# Publiс Subnets
################################################################################

# resource "aws_subnet" "public_subnet_01" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.public_subnet_01
#   availability_zone = var.az_1a
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet-01-ap-southeast-1a"
#   }
# }

# resource "aws_subnet" "public_subnet_02" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.public_subnet_02
#   availability_zone = var.az_1b
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet-02-ap-southeast-1b"
#   }
# }

# resource "aws_subnet" "public_subnet_03" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.public_subnet_03
#   availability_zone = var.az_1c
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "public-subnet-03-ap-southeast-1c"
#   }
# }

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-0${count.index+1}-${data.aws_availability_zones.azs.names[count.index]}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name= "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.public_igw.id
}

resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-igw"
  }
}
################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "private-subnet-0${count.index+1}-${data.aws_availability_zones.azs.names[count.index]}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name= "private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.public_igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnets[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.public_igw]
}

################################################################################
# DB Subnets
################################################################################

resource "aws_subnet" "db_subnets" {
  count = length(var.db_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "db-subnet-0${count.index+1}-${data.aws_availability_zones.azs.names[count.index]}"
  }
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name= "db-route-table"
  }
}

resource "aws_route_table_association" "db" {
  count = length(var.db_subnets)
  subnet_id = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.db_rt.id
}