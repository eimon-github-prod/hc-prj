###data.tf
data "aws_availability_zones" "azs" {
  state = "available"
}