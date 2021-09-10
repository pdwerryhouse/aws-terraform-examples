##    Terraform Examples
##    Copyright (C) 2021 Paul Dwerryhouse <paul@dwerryhouse.com.au>
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <https://www.gnu.org/licenses/>.

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  cidr_block = var.public_subnets[count.index]

  tags = {
    Name = "${var.name}-${var.env}-public-${count.index}"
  }
}

resource "aws_route_table_association" "public-a-internet" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-internet.id
}

