###variables.tf
# variable "public_subnet_01" {
#   default = "10.10.1.0/24"
#   description = "public-subnet-01"
# }

# variable "az_1a" {
#   type = string
#   default = "ap-southeast-1a"
#   description = "availability_zone"
# }

# variable "public_subnet_02" {
#   default = "10.10.2.0/24"
#   description = "public-subnet-02"
# }

# variable "az_1b" {
#   type = string
#   default = "ap-southeast-1b"
#   description = "availability_zone"
# }

# variable "public_subnet_03" {
#   default = "10.10.3.0/24"
#   description = "public-subnet-03"
# }

# variable "az_1c" {
#   type = string
#   default = "ap-southeast-1c"
#   description = "availability_zone"
# }

variable "public_subnets" {
  default = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
  description = "public-subnets"
}

variable "private_subnets" {
  default = ["10.10.4.0/24","10.10.5.0/24","10.10.6.0/24"]
  description = "private-subnets"
}

variable "db_subnets" {
  default = ["10.10.7.0/24","10.10.8.0/24","10.10.9.0/24"]
  description = "db-subnets"
}






