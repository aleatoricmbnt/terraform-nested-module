resource "null_resource" "show_scalr_env_vars" {
  triggers = {
    time = timestamp()
  }  
  provisioner "local-exec" {
    command = "printenv | grep SCALR"
  }
}

resource "random_string" "strings" {
  count = 4
  length = 8
  keepers = {
    time = timestamp()
  }
  depends_on = [ null_resource.show_scalr_env_vars ]
}

data "null_data_source" "some_values" {
  inputs = {
    first_pair = "${random_string.strings[0].id}, ${random_string.strings[1].id}"
    second_pair = "${random_string.strings[2].id}, ${random_string.strings[3].id}"
  }
}

data "archive_file" "dummy" {
  type        = "zip"
  source_file = "${path.module}/file.dummy"
  output_path = "${path.module}/file_dummy.zip"
  depends_on = [ data.null_data_source.some_values ]
}

resource "null_resource" "show_files_after_packing" {
  triggers = {
    archive = data.archive_file.dummy.id
  }
  provisioner "local-exec" {
    command = "ls -la"
  }
}

module "temp" {
  source = "./temp"
  trigger = var.top-level-trigger
}

variable "top-level-trigger" {
  default = "lol"
}

output "all_strings_from_data" {
  value = jsonencode({
    first_pair = data.null_data_source.some_values.outputs["first_pair"]
    second_pair = data.null_data_source.some_values.outputs["second_pair"]
  })
}
