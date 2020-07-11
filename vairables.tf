variable "vpc_ip" {
    type = string
    default = "10.0.0.0/16"
}
variable "public_ip" {
    type = string
    default = "10.0.0.0/24"
}
variable "public_ip2" {
    type = string
    default = "10.0.1.0/24"
}
variable "private_ip" {
    type = string
    default = "10.0.2.0/24"
}
variable "app_name" {
    type = string
    default = "terraform"
}
variable "image_id" {
    type = string
    default = "ami-005956c5f0f757d37"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
