variable "owner" {
  description = "Owner of the resource"
  type        = string
}

variable "service_name" {
  description = "This is the name of the corresponding Service that is being managed by IAC"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
