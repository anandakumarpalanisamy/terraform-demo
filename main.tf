provider "aws" {
  region = "eu-west-2"
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.api_name}-${var.env_name}"
}

data "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.api_name}-${var.env_name}"
  depends_on = [
    aws_api_gateway_rest_api.rest_api
  ]
}

module "list-restaurants-api" {
  source = "./modules/api-gateway"

  api_name = "${var.api_name}-${var.env_name}"
  parent_id = data.aws_api_gateway_rest_api.rest_api.root_resource_id
  path     = "restaurants"
  method   = "GET"
  integration = {
    type   = "HTTP"
    method = "GET"
    uri    = "https://alb-dev.speedy.zizzi.co.uk/restaurants"
  }
  request_parameters = {
    "method.request.header.x-brand" = true
  }
  integration_request_parameters = {
    "integration.request.header.x-brand" = "method.request.header.x-brand"
  }

  depends_on = [
    aws_api_gateway_rest_api.rest_api
  ]
}

module "get-restaurant-api" {
  source = "./modules/api-gateway"

  api_name = "${var.api_name}-${var.env_name}"
  parent_id = module.list-restaurants-api.aws_api_gateway_resource_id
  path     = "{restaurantId}"
  method   = "GET"
  integration = {
    type   = "HTTP"
    method = "GET"
    uri    = "https://alb-dev.speedy.zizzi.co.uk/restaurants/{restaurantId}"
  }
  request_parameters = {
    "method.request.path.restaurantId" = true
  }
  integration_request_parameters = {
    "integration.request.path.restaurantId" = "method.request.path.restaurantId"
  }

  depends_on = [
    aws_api_gateway_rest_api.rest_api,
    module.list-restaurants-api.aws_api_gateway_resource_id
  ]
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      module.list-restaurants-api.aws_api_gateway_resource_id,
      module.get-restaurant-api.aws_api_gateway_resource_id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_rest_api.rest_api,
    module.list-restaurants-api.aws_api_gateway_resource_id,
    module.list-restaurants-api.aws_api_gateway_resource_method_id,
    module.list-restaurants-api.aws_api_gateway_integration_id,
    module.list-restaurants-api.aws_api_gateway_resource_method_response_id,
    module.list-restaurants-api.aws_api_gateway_integration_response_id,
    module.get-restaurant-api.aws_api_gateway_resource_id,
    module.get-restaurant-api.aws_api_gateway_resource_method_id,
    module.get-restaurant-api.aws_api_gateway_integration_id,
    module.get-restaurant-api.aws_api_gateway_resource_method_response_id,
    module.get-restaurant-api.aws_api_gateway_integration_response_id,
  ]
}

resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = data.aws_api_gateway_rest_api.rest_api.id
  stage_name    = "${var.api_name}-${var.env_name}"

  depends_on = [
    aws_api_gateway_deployment.rest_api_deployment
  ]
}