data "aws_api_gateway_rest_api" "rest_api" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.rest_api.id
  parent_id   = var.parent_id
  path_part   = var.path
}

resource "aws_api_gateway_method" "rest_api_get_method" {
  rest_api_id   = data.aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_api_resource.id
  http_method   = var.method
  authorization = "NONE"

  request_parameters = var.request_parameters
}

resource "aws_api_gateway_integration" "rest_api_get_method_integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_api_resource.id
  http_method             = aws_api_gateway_method.rest_api_get_method.http_method
  integration_http_method = var.integration.method
  type                    = var.integration.type
  uri                     = var.integration.uri

  request_parameters = var.integration_request_parameters
}

resource "aws_api_gateway_method_response" "rest_api_get_method_response_200" {
  rest_api_id = data.aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.rest_api_get_method.http_method
  status_code = 200
}

resource "aws_api_gateway_integration_response" "rest_api_get_method_integration_response" {
  rest_api_id             = data.aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_api_resource.id
  http_method             = aws_api_gateway_method.rest_api_get_method.http_method
  status_code             = aws_api_gateway_method_response.rest_api_get_method_response_200.status_code
}