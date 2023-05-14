provider "aws" {
  profile = "3n-ab2-backend-nael"
  region  = "eu-west-3"
}

module "lambda_configs" {
  source = "./lambda_configs"
  #  project_abs_path=""
  #  lambda_source_path = "../fn"
  #  build_path =

}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  depends_on = [null_resource.build_go]
  for_each = module.lambda_configs.config_map

  function_name = each.key
  handler       = each.key
  runtime       = "go1.x"
  source_path   = each.value.build_output

  #  publish       = true
  #  create        = false


}

resource "null_resource" "build_go" {
  for_each = module.lambda_configs.config_map
  triggers = {
    file_version = "${each.value.go_package_version}"
  }

  provisioner "local-exec" {
    command = "GOOS=linux GOARCH=amd64 CGO_ENABLED=0   go build -o  ${each.value.build_output}  ${each.value.go_package_abs_path}"
  }
}
##=========================
#
module "lambda_function_alias" {
  source           = "terraform-aws-modules/lambda/aws//modules/alias"
  create           = false
  name             = "dev-hi"
  function_name    = "hi"
  function_version = "2"
}
