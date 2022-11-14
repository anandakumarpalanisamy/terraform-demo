variable "api_name" {
  description = "name of the api"
  type = string
}

variable "parent_id" {
  description = "parent resource id"
  type = string
}

variable "path" {
  description = "name of the rest api resource path"
  type = string
}

variable "method" {
  description = "name of the rest api http method"
  type = string
}

variable "integration" {
  description = "api integration configuration"
  type = map
}

variable "request_parameters" {
  description = "request parameter mappings"
  type = map
}

variable "integration_request_parameters" {
  description = "integration request parameter mappings"
  type = map
}