provider "aws" {
  profile = "3n-ab2-backend-nael"
  region  = "eu-west-3"
}
locals {
  files = fileset("${path.module}/../fn/", "*.go" )
}

module "lambda_function" {
  depends_on    = [null_resource.build_go]
  for_each      = local.files
  source        = "terraform-aws-modules/lambda/aws"
  function_name = trimsuffix(each.value, ".go")
  handler       = trimsuffix(each.value, ".go")
  runtime       = "go1.x"
#  publish       = true

  source_path = "${path.module}/builds/${trimsuffix(each.value,".go")}"

}

resource "null_resource" "build_go" {
  for_each = local.files
  triggers = {
    file_version = filesha1( "${path.module}/../fn/${each.value}")
  }

  provisioner "local-exec" {
    command = "GOOS=linux GOARCH=amd64 CGO_ENABLED=0   go build -o  ${path.module}/builds/${trimsuffix(each.value,".go")}  ${path.module}/../fn/${each.value}"
  }
}
#=========================

module "lambda_function_alias" {
  source  = "terraform-aws-modules/lambda/aws//modules/alias"
  name = "dev-hi"
  function_name = "hi"
  function_version = "2"
}

#resource "null_resource" "rm_go_exe" {
#  depends_on = [module.lambda_function]
#  triggers = {
#    apply = timestamp()
#  }
#  provisioner "local-exec" {
#    command = "rm  ${path.module}/../fn/hello "
#  }
#}