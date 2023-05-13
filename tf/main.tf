provider "aws" {
  profile = "3n-ab2-backend-nael"
  region  = "eu-west-3"
}


module "lambda_function" {
  depends_on    = [null_resource.build_go]
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "hello"
  handler       = "hello"
  runtime       = "go1.x"
  publish       = true

  source_path = "${path.module}/builds/hello"

}

resource "null_resource" "build_go" {
  triggers = {
    file_version =filesha1( "${path.module}/../fn/hello.go")
  }

  provisioner "local-exec" {
    command = "GOOS=linux GOARCH=amd64 CGO_ENABLED=0   go build -o  ${path.module}/builds/hello  ${path.module}/../fn/hello.go"
  }
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