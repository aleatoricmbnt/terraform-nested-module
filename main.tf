resource "random_pet" "resource" {
  count = 3
  keepers = {
    timestamp = timestamp()
    number = var.user_number
  }
}

variable "user_number" {
  type = number
  description = "pet keeper 1/2"
}
