locals {
  project_name = "terraform-shipping-lab"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = local.project_name
  }
}