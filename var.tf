variable "name" {
  type    = string
  default = "Armand"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "versioning" {
  type    = string
  default = "Enabled"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "create_bucket" {
  type    = bool
  default = true
}