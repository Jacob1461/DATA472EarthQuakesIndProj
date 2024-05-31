variable "name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "DATA472-jcl173-earthquakesapi"
}

variable "course" {
  description = "The course name"
  type        = string
  default     = "DATA472"
}

variable "username" {
  description = "The student or user name"
  type        = string
  default     = "jcl173"
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "Machine type"
  type        = string
  default     = "t2.small"
}

variable "vpc_security_group_ids" {
  description = "VPC Security group IDs"
  type        = list(string)
  default     = ["sg-09b486a14a006c62b"]
}

variable "instance_keypair_name" {
  description = "Name of keypair"
  type        = string
  default     = "DATA472-jcl173-2"
}


variable "ami" {
  description = "Amazon machine image"
  type = string
  default = "ami-080660c9757080771"
}

variable "subnetid" {
  description = "The subnet id for machine"
  type = string
  default = "subnet-0326da008b859395c"
}

variable "volumesize" {
  description = "Space on the volumn"
  type = number
  default = 20
}