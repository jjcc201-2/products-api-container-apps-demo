variable "location" {
  description = "The Azure region to deploy all resources."
  type        = string
  default     = "uksouth"
}

variable "environment" {
  description = "The type of environment."
  type        = string
  default     = "dev"
}

variable "rg_name" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-products-dev"
}

variable "cae_name" {
  description = "The name of the app service plan."
  type        = string
  default     = "cae-products-dev"
}

variable "ca_name" {
  description = "The name of the app service plan."
  type        = string
  default     = "ca-api-products-dev"
}

variable "dockerhub_image_name" {
  description = "The name of the dockerhub image."
  type        = string
  default     = "docker2948191/products-backend:latest"
}


variable "law_name" {
  description = "The name of the log analytics workspace."
  type        = string
  default     = "law-products-dev"
}
