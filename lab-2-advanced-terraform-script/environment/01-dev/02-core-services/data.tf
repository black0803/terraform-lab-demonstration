data "aws_vpc" "vpc"{
    filter {
        name   = "tag:ResourceID"
        values = ["msi-labs"]
    }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:Subnet"
    values = ["Private"]
  }
}

data "aws_subnet" "private_subnet" {
  for_each = toset(data.aws_subnets.private_subnets.ids)
  id       = each.value
}