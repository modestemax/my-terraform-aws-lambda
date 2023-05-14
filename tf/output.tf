
output "lambda_configs" {
  value = module.lambda_configs
}
output "go_packages" {
  value = [for k,v in  module.lambda_configs.config_map: v.go_package]
}

