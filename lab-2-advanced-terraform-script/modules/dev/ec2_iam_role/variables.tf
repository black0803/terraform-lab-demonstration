variable "prefix" {
  default = ""
  type    = string
}

variable "policy_arns" {
  default = []
  type    = list(string)
}

variable "tags" {
  default = {}
  type    = map(string)
}