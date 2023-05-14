variable "project_abs_path" {
  default = "/Users/ulalo/Projects/terraform/aws/lambda-v3"
}
variable "lambda_source_path" {
  default = "fn"
}
variable "tf_path" {
  default = "tf"
}
variable "build_path" {
  default = "builds"
}


locals {
  build_abs_path         = "${var.project_abs_path}/${var.tf_path}/${var.build_path}"
  lambda_source_abs_path = "${var.project_abs_path}/${var.lambda_source_path}"

  files      = fileset("${var.project_abs_path}/${var.lambda_source_path}/**/", "main.go" )
  config_map = {
    for file in local.files :element(  split("/", file ), length(split("/", file ))-2)=>{

      go_package          = element(  split("/", file ), length(split("/", file ))-2)
      build_output        = "${local.build_abs_path}/${element(  split("/",file ),length(split("/",file ))-2)}"
      go_package_abs_path = "${local.lambda_source_abs_path}/${element(  split("/", file ), length(split("/", file ))-2)}"
      go_package_version  = sha1(join("", [
        for f in  fileset("${var.project_abs_path}/${var.lambda_source_path}/${element(  split("/", file ), length(split("/", file ))-2)  }", "*") :
        filesha1("${var.project_abs_path}/${var.lambda_source_path}/${element(  split("/", file ), length(split("/", file ))-2)  }/${f}")
      ]))

    }
  }
}

output "config_map" {
  value = local.config_map
}