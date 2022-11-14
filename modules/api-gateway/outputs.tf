output "aws_api_gateway_resource_id" {
  value = aws_api_gateway_resource.rest_api_resource.id
}

output "aws_api_gateway_resource_method_id" {
  value = aws_api_gateway_method.rest_api_get_method.id
}

output "aws_api_gateway_integration_id" {
  value = aws_api_gateway_integration.rest_api_get_method_integration.id
}

output "aws_api_gateway_resource_method_response_id" {
  value = aws_api_gateway_method_response.rest_api_get_method_response_200.id
}

output "aws_api_gateway_integration_response_id" {
  value = aws_api_gateway_integration_response.rest_api_get_method_integration_response.id
}