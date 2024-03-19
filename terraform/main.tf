// Create random ID for resource group, environment, log analytics workspace and container name
resource "random_id" "rg_name" {
  byte_length = 8
}

resource "random_id" "env_name" {
  byte_length = 8
}

resource "random_id" "law_name" {
  byte_length = 8
}

resource "random_id" "container_name" {
  byte_length = 4
}



# Azure resource group resource
resource "azurerm_resource_group" "rg-products" {
  name     = "${var.rg_name}-${random_id.rg_name.hex}"
  location = var.location
  tags = {
    environment = "${var.environment}"
  }
}

# Log Analytics resource
resource "azurerm_log_analytics_workspace" "law-products" {
  name                = "${var.law_name}-${random_id.law_name.hex}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-products.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    environment = "${var.environment}"
  }
}

// Azure Container Apps environment
resource "azurerm_container_app_environment" "cae-products" {
  name                       = "${var.cae_name}-${random_id.env_name.hex}"
  resource_group_name        = azurerm_resource_group.rg-products.name
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law-products.id
}

// Container App for the web front end
resource "azurerm_container_app" "ca-products-api" {
  name                         = "${var.ca_name}-${random_id.container_name.hex}"
  resource_group_name          = azurerm_resource_group.rg-products.name
  container_app_environment_id = azurerm_container_app_environment.cae-products.id
  revision_mode                = "Single"

  template {
    container {
      name   = "products-api"
      image  = "docker2948191/products-api:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
    min_replicas    = 0
    max_replicas    = 3
    revision_suffix = "apiv1"
  }

  // Ingress where external access is not allowed
  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 3000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

}


# Terraform is a declarative language, meaning you tell it what you want and it will figure out how to do it
# PowerShell is an imperative language, meaning you tell it how to do something

# Terraform is idempotent, meaning you can run the same script over and over again and it will only make the changes that are needed
# PowerShell is not idempotent, meaning if you run the same script over and over again, it will make the same changes over and over again

# Terraform is stateful by default, meaning it keeps track of the resources it creates
# PowerShell is stateless, meaning it doesn't keep track of the resources it creates

# Terraform commands that are useful
# terraform init - initializes the terraform project
# terraform fmt - formats the terraform code
# terraform plan - shows what terraform will do before it does it e.g. create, update, delete
# terraform apply -auto-approve - applies the changes to the cloud provider
# terraform apply -refresh-only - refreshes the state file without making any changes
# terraform state list - lists the resources that terraform is keeping track of
# terraform destroy -auto-approve - destroys all the resources that terraform is keeping track of
# terraform output - shows the outputs of the terraform project