#comment
resource "random_pet" "resource" {
  count = var.quantity
  keepers = {
    timestamp = timestamp()
    number = var.user_number
    string = var.var-var-var
  }
}

variable "user_number" {
  type = number
  description = "keeper var 1/22"
}

variable "var-var-var" {
  default = "ya masha 123"
}

variable "quantity" {
  sensitive = true
  default = 1234
}